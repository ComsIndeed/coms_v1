//  `{"action": "set_reminder", "params": {"when": "YYYY-MM-DD-HH-MM", "title": "TITLE GOES HERE", "body": "BODY GOES HERE"}}`

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/date_time_view.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';

class ReminderWidget extends StatelessWidget {
  final String id;
  final String title;
  final String body;
  final int creationDateEpoch =
      DateTime.fromMillisecondsSinceEpoch(0).millisecond;
  final DateTime dateTime;
  final String dateTimeString;

  ReminderWidget(
      {super.key,
      required this.title,
      required this.body,
      required this.dateTimeString,
      required this.id,
      required this.dateTime});

  static ReminderWidget fromJson(params) {
    final dateTime = DateTime.parse(params["dateTimeString"]);
    final reminderWidget = ReminderWidget(
      id: params["id"],
      title: params["title"],
      body: params["body"],
      dateTimeString: params["dateTimeString"],
      dateTime: dateTime,
    );
    return reminderWidget;
  }

  String toJson() {
    Map<String, dynamic> serializedWidget = {
      "key": "reminder_widget",
      "params": {
        "id": id,
        "title": title,
        "body": body,
        "dateTimeString": dateTime.toIso8601String(),
      }
    };

    final json = jsonEncode(serializedWidget);
    return json;
  }

  void navigateToPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReminderWidgetPage(
                id: id, title: title, body: body, dateTime: dateTime)));
  }

  void scheduleReminder() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: creationDateEpoch,
        channelKey: 'reminders',
        actionType: ActionType.Default,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: dateTime.second,
          millisecond: dateTime.millisecond,
          repeats: false, // Set to true for recurring notifications
          timeZone: "GMT+00:00"),
    );
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
          child: ListTile(
            title: Text(title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(body),
                const SizedBox(height: 24),
                DateTimeView(dateTime: dateTime),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
