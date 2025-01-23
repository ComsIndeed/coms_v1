import 'dart:convert';

import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widgets/note_widget/note_widget_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

//  `{"action": "set_note", "params": {"title": "TITLE GOES HERE", "body": "BODY GOES HERE"}}`

class NoteWidget extends StatelessWidget {
  final String id;
  final String? title;
  final String? body;

  const NoteWidget({super.key, this.title, this.body, required this.id});

  static NoteWidget fromJson(params) {
    return NoteWidget(
      id: params["id"] as String,
      title: params["title"] as String,
      body: params["body"] as String,
    );
  }

  String toJson() {
    return jsonEncode({
      'key': 'note_widget',
      'params': {
        'id': id,
        'title': title,
        'body': body,
      },
    });
  }

  void navigateToPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteWidgetPage(
                  title: title,
                  body: body,
                  id: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final widgetMapProvider = Provider.of<WidgetMapProvider>(context);

    var actionPane = ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => widgetMapProvider.removeWidget(id),
          icon: Icons.delete,
          label: "Delete",
          backgroundColor: Colors.transparent,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        key: ValueKey(id),
        startActionPane: actionPane,
        endActionPane: actionPane,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.white24)),
          ),
          onPressed: () => navigateToPage(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(title ?? "No title"),
                subtitle: MarkdownBody(
                  data: body ?? "No body",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
