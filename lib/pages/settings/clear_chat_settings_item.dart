import 'package:coms/classes/coms/main_conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearChatSettingsItem extends StatelessWidget {
  const ClearChatSettingsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainConversationProvider =
        Provider.of<MainConversationProvider>(context);
    return ListTile(
      title: const Text("Clear chat history"),
      subtitle: const Text("Delete existing chat history (IRREVERSIBLE)"),
      trailing: IconButton.filledTonal(
          style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 100, 0, 0)),
          onPressed: mainConversationProvider.clearHistory,
          icon: const Icon(Icons.delete)),
    );
  }
}
