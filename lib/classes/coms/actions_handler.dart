import 'dart:convert';

import 'package:coms/classes/coms/prompts/main_conversation_prompt.dart';
import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widgets/note_widget/note_widget.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ActionsHandler with ChangeNotifier {
  final WidgetMapProvider widgetMapProvider;

  ActionsHandler({required this.widgetMapProvider});

  void runAction(String actionName, Map<String, dynamic> params) {
    const uuid = Uuid();
    final id = uuid.v4();

    /// !!! HERE ======================================================
    /// !!! HERE =========== ADD NEW ACTIONS HERE =====================
    /// !!! HERE ======================================================
    final Map<String, Function(Map<String, dynamic>)> actions = {
      // ! CREATE REMINDER
      "create_reminder": (Map<String, dynamic> params) {
        final dateTime = DateTime.parse(params["iso8601_date"])
            .toLocal(); // 16:00:00 without a Z, given 2025-01-19T00:00:00+08:00
        Fluttertoast.showToast(
            msg:
                "INPUT: ${params["iso8601_date"]}\nLOCALIZED: ${dateTime.toIso8601String()}",
            toastLength: Toast.LENGTH_LONG);
        // Fluttertoast.showToast(msg: "$dateTime");
        final reminderWidget = ReminderWidget(
          id: id,
          title: params["title"],
          body: params["body"],
          dateTimeString: params["iso8601_date"],
          dateTime: dateTime,
        );
        final serializedReminderWidget = reminderWidget.toJson();
        widgetMapProvider.addWidget(serializedReminderWidget);
        reminderWidget.scheduleReminder();
      },
      // ! CREATE NOTE
      "create_note": (Map<String, dynamic> params) {
        final noteWidget =
            NoteWidget(id: id, title: params["title"], body: params["body"]);
        final serializedNoteWidget = noteWidget.toJson();
        widgetMapProvider.addWidget(serializedNoteWidget);
      },
      // ! DELETE WIDGET
      "delete_widget": (Map<String, dynamic> params) {
        widgetMapProvider.removeWidget(params["id"]);
      },
      // ! UPDATE WIDGET
      "update_widget": (Map<String, dynamic> params) {
        // TODO: Requires handling different widgets. Difficult.
        // For now, we use something simple.
      },
    };

    if (actions[actionName] == null) throw Exception("Undefined $actionName");

    actions[actionName]!(params);
  }
}
