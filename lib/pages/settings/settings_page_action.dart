import 'package:coms/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

class SettingsPageAction extends StatefulWidget {
  const SettingsPageAction({super.key});

  @override
  State<SettingsPageAction> createState() => _SettingsPageActionState();
}

class _SettingsPageActionState extends State<SettingsPageAction> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "All set, Vince",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
