import 'package:coms/classes/widgetList/widgets/widget_status_indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteWidgetPage extends StatefulWidget {
  final String id;
  final String? title;
  final String? body;

  const NoteWidgetPage(
      {super.key, required this.id, required this.title, required this.body});

  @override
  State<NoteWidgetPage> createState() => _NoteWidgetPageState();
}

class _NoteWidgetPageState extends State<NoteWidgetPage> {
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
              const SizedBox(height: 96),
              const WidgetStatusIndicators(),
            ],
          ),
        ),
      ),
    );
  }
}
