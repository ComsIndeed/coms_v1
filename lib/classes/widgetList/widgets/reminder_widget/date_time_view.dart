//  `{"action": "set_reminder", "params": {"when": "YYYY-MM-DD-HH-MM", "title": "TITLE GOES HERE", "body": "BODY GOES HERE"}}`

import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

class DateTimeView extends StatelessWidget {
  const DateTimeView({
    super.key,
    required this.dateTime,
    this.show8601 = false,
  });

  final DateTime dateTime;
  final bool show8601;

  @override
  Widget build(BuildContext context) {
    final moment = dateTime.toMoment();

    return Row(
      children: [
        const Icon(Icons.alarm),
        const SizedBox(width: 12),
        Text(
          "${moment.lll},\n${moment.fromNow()}",
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
