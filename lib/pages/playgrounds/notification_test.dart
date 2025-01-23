import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({
    super.key,
  });

  @override
  State<NotificationTest> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  void runNotificationTest() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'dev',
      actionType: ActionType.Default,
      title: 'Hello World!',
      body: 'This is my first notification!',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Notification test"),
      subtitle: const Text("Just a basic test for notifications"),
      leading: const Icon(Icons.notifications),
      trailing: TextButton(
          onPressed: runNotificationTest, child: const Text("Run test")),
    );
  }
}
