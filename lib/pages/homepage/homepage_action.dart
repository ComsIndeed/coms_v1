import 'package:coms/classes/utils/get_greeting.dart';
import 'package:coms/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

class HomepageAction extends StatefulWidget {
  const HomepageAction({
    super.key,
  });

  @override
  State<HomepageAction> createState() => _HomepageActionState();
}

class _HomepageActionState extends State<HomepageAction> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ));
      },
      child: Text(
        "${getGreeting()}, Vince",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
