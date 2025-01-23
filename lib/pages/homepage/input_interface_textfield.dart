import 'package:coms/classes/coms/actions_handler.dart';
import 'package:coms/classes/coms/main_conversation_provider.dart';
import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:coms/classes/gemini/gemini_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputInterfaceTextfield extends StatefulWidget {
  final TextEditingController textfieldController;
  final bool isProcessing;
  final VoidCallback checkButtonVisibility;
  final Function(MainConversationProvider, GeminiProvider, ActionsHandler,
      TerminalProvider) sendMessage;
  final bool isSendButtonVisible;

  const InputInterfaceTextfield({
    super.key,
    required this.textfieldController,
    required this.isProcessing,
    required this.checkButtonVisibility,
    required this.sendMessage,
    required this.isSendButtonVisible,
  });

  @override
  State<InputInterfaceTextfield> createState() =>
      _InputInterfaceTextfieldState();
}

class _InputInterfaceTextfieldState extends State<InputInterfaceTextfield> {
  @override
  void initState() {
    super.initState();

    widget.textfieldController.addListener(widget.checkButtonVisibility);
  }

  @override
  Widget build(BuildContext context) {
    final mainConversationProvider =
        Provider.of<MainConversationProvider>(context);
    final geminiProvider = Provider.of<GeminiProvider>(context);
    final actionsHandlerProvider = Provider.of<ActionsHandler>(context);
    final terminalProvider = Provider.of<TerminalProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextField(
        controller: widget.textfieldController,
        maxLines: 3,
        enabled: !widget.isProcessing,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Type here...",
            suffixIcon: widget.isSendButtonVisible
                ? IconButton(
                    onPressed: () {
                      widget.sendMessage(
                          mainConversationProvider,
                          geminiProvider,
                          actionsHandlerProvider,
                          terminalProvider);
                    },
                    icon: const Icon(Icons.send))
                : null),
      ),
    );
  }
}
