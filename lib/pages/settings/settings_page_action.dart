import 'package:coms/classes/coms/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPageAction extends StatefulWidget {
  const SettingsPageAction({super.key});

  @override
  State<SettingsPageAction> createState() => _SettingsPageActionState();
}

class _SettingsPageActionState extends State<SettingsPageAction> {
  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "All set, ${firebaseProvider.auth.currentUser?.displayName ?? "user"}",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
