import 'package:coms/classes/widgetList/widgets/reminder_widget/date_time_view.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:moment_dart/moment_dart.dart';

class ReminderWidgetPage extends StatefulWidget {
  final String id;
  final String? title;
  final String? body;
  final DateTime dateTime;

  const ReminderWidgetPage(
      {super.key,
      required this.id,
      required this.title,
      required this.body,
      required this.dateTime});

  @override
  State<ReminderWidgetPage> createState() => _ReminderWidgetPageState();
}

class _ReminderWidgetPageState extends State<ReminderWidgetPage> {
  void showChat(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  right: 8,
                  left: 8,
                  top: 8,
                  bottom: 20,
                ),
                child: Text("data"),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton.outlined(
          onPressed: () => showChat(context), icon: const Icon(Icons.chat)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      widget.title ?? "No title",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton.outlined(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton.outlined(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close))
                    ],
                  )
                ],
              ),
              const Divider(),
              MarkdownBody(
                data: widget.body ?? "No body",
                selectable: true,
              ),
              const SizedBox(height: 24),
              DateTimeView(dateTime: widget.dateTime)
            ],
          ),
        ),
      ),
    );
  }
}
