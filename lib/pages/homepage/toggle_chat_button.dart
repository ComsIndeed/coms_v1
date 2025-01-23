import 'package:flutter/material.dart';

class ToggleChatButton extends StatelessWidget {
  final VoidCallback toggleChat;

  const ToggleChatButton({super.key, required this.toggleChat});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
        onPressed: toggleChat, icon: const Icon(Icons.chat));
  }
}
