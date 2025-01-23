import 'dart:convert';

import 'package:coms/classes/coms/main_conversation_provider.dart';
import 'package:coms/classes/coms/prompts/main_conversation_prompt.dart';
import 'package:coms/classes/dev_utils/trim_code_block.dart';
import 'package:coms/pages/homepage/action_displays.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moment_dart/moment_dart.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();

      final mainConversationProvider =
          Provider.of<MainConversationProvider>(context, listen: false);

      mainConversationProvider.addListener(scrollToBottom);
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<String> handleMessageDifferentiation(Content chatMessage) async {
    final prefs = await SharedPreferences.getInstance();
    final isJsonView = prefs.getBool("settings.useJsonView") ?? false;

    if (chatMessage.role == "model") {
      if (isJsonView) {
        return chatMessage.parts
            .whereType<TextPart>()
            .map((textPart) => textPart.text)
            .join("\n\n");
      }

      final encodedJson = trimCodeBlock(chatMessage.parts
          .whereType<TextPart>()
          .map((textPart) => textPart.text)
          .join("\n\n"));

      final json = jsonDecode(encodedJson);
      final String? messageText = json["text"];
      return messageText ?? "No text";
    } else {
      final encodedMessage = chatMessage.parts
          .whereType<TextPart>()
          .map((textPart) => textPart.text)
          .join("\n\n");
      final Map<String, dynamic> message = jsonDecode(encodedMessage);
      return message["user_message"]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainConversationProvider =
        Provider.of<MainConversationProvider>(context);

    final chatList = mainConversationProvider.serializableChatSession.history
        .map((chatMessage) => FutureBuilder<String>(
              future: handleMessageDifferentiation(chatMessage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text("Loading..."),
                    subtitle: Text("Processing message..."),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(chatMessage.role == "user" ? "You" : "Model"),
                    subtitle: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  String sendDate = "";
                  if (chatMessage.role == "user") {
                    final encodedMessage = chatMessage.parts
                        .whereType<TextPart>()
                        .map((textPart) => textPart.text)
                        .join("\n\n");
                    final decodedMessage = jsonDecode(encodedMessage);
                    final metadata = decodedMessage["metadata"];
                    final iso8601 = metadata["iso8601_date"];
                    sendDate =
                        DateTime.parse(iso8601).toLocal().toMoment().llll;
                  }

                  return ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(chatMessage.role == "user" ? "You" : "Model"),
                        const SizedBox(width: 16),
                        chatMessage.role == "user"
                            ? Text(
                                sendDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(snapshot.data ?? "No content"),
                        ActionDisplays(chatMessage: chatMessage),
                      ],
                    ),
                  );
                }
              },
            ))
        .toList();

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.3),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                if (chatList.isEmpty) const Text("No messages"),
                ...chatList,
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
