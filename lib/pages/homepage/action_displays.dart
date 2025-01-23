import 'dart:convert';
import 'package:coms/classes/dev_utils/trim_code_block.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:moment_dart/moment_dart.dart';

class ActionDisplays extends StatelessWidget {
  final Content chatMessage;
  const ActionDisplays({super.key, required this.chatMessage});

  // TODO : When a chat action button is clicked, scroll to the created widget
  // TODO : Create custom buttons for each action types

  String getActionText(Map<String, dynamic> actionItem) {
    final String actionItemName = actionItem["action"];
    final Map<String, dynamic> params = actionItem["params"];

    switch (actionItemName) {
      case "create_reminder":
        return "Reminder scheduled for ${DateTime.tryParse(params["iso8601_date"])?.toMoment().toLocal().lll} or ${params["iso8601_date"]}";
      default:
        return actionItemName;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chatMessage.role == "model") {
      final encodedJson = trimCodeBlock(chatMessage.parts
          .whereType<TextPart>()
          .map((textPart) => textPart.text)
          .join("\n\n"));
      final json = jsonDecode(encodedJson);
      final List<dynamic> actions = json["actions"];
      return Wrap(
        children: actions
            .map((actionItem) => TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.3)),
                  onPressed: () {},
                  child: Text(
                    getActionText(actionItem),
                  ),
                ))
            .toList(),
      );
    } else {
      return const SizedBox();
    }
  }
}
