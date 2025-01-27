import 'package:coms/classes/coms/prompts/main_conversation_prompt.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:coms/pages/playgrounds/firebase_initialize.dart';
import 'package:coms/pages/playgrounds/firestore_test.dart';
import 'package:coms/pages/playgrounds/flutter_js.dart';
import 'package:coms/pages/playgrounds/notification_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:colorful_iconify_flutter/icons/vscode_icons.dart';

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
              Time(),
              SizedBox(
                height: 10,
              ),
              FirebaseInitialize(),
              FirestoreTest(),
              NotificationTest(),
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
    return ExpansionTile(
        title: const Text("Main Conversation Prompt"),
        subtitle: const Text("The main prompt template for the conversation"),
        children: [MarkdownBody(data: getMainConversationPrompt())]);
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
