import 'dart:convert';
import 'dart:io';

import 'package:coms/classes/coms/actions_handler.dart';
import 'package:coms/classes/coms/main_conversation_provider.dart';
import 'package:coms/classes/coms/prompts/main_conversation_prompt.dart';
import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:coms/classes/dev_utils/trim_code_block.dart';
import 'package:coms/classes/gemini/attachment/attachment.dart';
import 'package:coms/classes/gemini/gemini_provider.dart';
import 'package:coms/pages/homepage/attachment_list.dart';
import 'package:coms/pages/homepage/camera_button.dart';
import 'package:coms/pages/homepage/chat_view.dart';
import 'package:coms/pages/homepage/input_interface_textfield.dart';
import 'package:coms/pages/homepage/mic_button.dart';
import 'package:coms/pages/homepage/toggle_chat_button.dart';
import 'package:coms/pages/settings/terminal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:moment_dart/moment_dart.dart';

class InputInterface extends StatefulWidget {
  const InputInterface({super.key});

  @override
  State<InputInterface> createState() => _InputInterfaceState();
}

class _InputInterfaceState extends State<InputInterface> {
  bool isProcessing = false;
  bool isSendButtonVisible = false;
  bool isChatVisible = false;
  List<Attachment> attachments = [];
  final textfieldController = TextEditingController();

  void checkButtonVisibility() {
    setState(() {
      isSendButtonVisible =
          attachments.isNotEmpty || textfieldController.text.isNotEmpty;
    });
    print(attachments.isNotEmpty || textfieldController.text.isNotEmpty);
  }

  void addAttachment(Attachment attachment) {
    setState(() {
      attachments.add(attachment);
    });
    checkButtonVisibility();
  }

  void removeAttachment(Attachment attachment) {
    if (attachment.path != null) File(attachment.path!).delete();
    setState(() {
      attachments.remove(attachment);
    });
    checkButtonVisibility();
  }

  void sendMessage(
      MainConversationProvider mainConversationProvider,
      GeminiProvider geminiProvider,
      ActionsHandler actionsHandlerProvider,
      TerminalProvider terminalProvider) async {
    setState(() {
      isProcessing = true;
    });

    try {
      if (geminiProvider.apiKey == null) {
        Fluttertoast.showToast(msg: "No API key provided");
        return;
      }

      final attachmentParts = await Future.wait(
          attachments.map((attachment) => attachment.asPart()));
      final Map<String, dynamic> textpartMap = {
        "metadata": {
          "iso8601_date": DateTime.now().toLocal().toIso8601String(),
          "date_send": DateTime.now().toLocal().toMoment().lll,
          "location": "Manila, Philippines",
        },
        "user_message": textfieldController.text
      };
      final textpart = TextPart(jsonEncode(textpartMap));
      final message = Content("user", [textpart, ...attachmentParts]);

      final model = geminiProvider.getModel(
          modelName: "gemini-1.5-flash",
          tools: [Tool(codeExecution: CodeExecution())],
          systemInstructions: getMainConversationPrompt());
      final chat = mainConversationProvider.serializableChatSession;

      final response = await chat.sendMessage(
          model: model, message: message, apiKey: geminiProvider.apiKey!);

      if (response.text == null) {
        Fluttertoast.showToast(msg: "Response text is null");
        return;
      }

      final encodedJson = trimCodeBlock(response.text!);
      final json = jsonDecode(encodedJson);
      final List<dynamic> actions = json["actions"];
      for (var action in actions) {
        actionsHandlerProvider.runAction(action["action"], action["params"]);
      }

      textfieldController.clear();
    } catch (e, s) {
      Fluttertoast.showToast(msg: "Error: $e");
      terminalProvider.add("$e, $s");
    } finally {
      setState(() {
        isProcessing = false;
      });
      mainConversationProvider.notifyChanges();
      mainConversationProvider.saveChanges();
    }
  }

  void toggleChat() {
    setState(() {
      isChatVisible = !isChatVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Colors.white24),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          duration: Durations.short4,
          child: Column(
            children: [
              if (isChatVisible) const ChatView(),
              if (!isChatVisible)
                AttachmentList(
                    attachments: attachments,
                    deleteAttachment: removeAttachment),
              InputInterfaceTextfield(
                  isSendButtonVisible: isSendButtonVisible,
                  checkButtonVisibility: checkButtonVisibility,
                  isProcessing: isProcessing,
                  textfieldController: textfieldController,
                  sendMessage: sendMessage),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleChatButton(toggleChat: toggleChat),
                  MicButton(addAttachment: addAttachment),
                  const CameraButton(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
