import 'package:coms/classes/coms/prompts/main_conversation_prompt.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:coms/pages/playgrounds/flutter_js.dart';
import 'package:coms/pages/playgrounds/notification_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:moment_dart/moment_dart.dart';

class PlaygroundsPage extends StatelessWidget {
  const PlaygroundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Funny playground"),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              NotificationTest(),
              Time(),
              Prompt(),
            ],
          ),
        ),
      ),
    );
  }
}

class Prompt extends StatelessWidget {
  const Prompt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(data: getMainConversationPrompt());
  }
}

class Time extends StatelessWidget {
  const Time({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(DateTime.now().toMoment().LLLL);
  }
}
