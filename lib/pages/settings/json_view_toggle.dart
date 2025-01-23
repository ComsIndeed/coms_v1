import 'package:coms/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonViewToggle extends StatefulWidget {
  const JsonViewToggle({
    super.key,
  });

  @override
  State<JsonViewToggle> createState() => _JsonViewToggleState();
}

class _JsonViewToggleState extends State<JsonViewToggle> {
  final String key = "settings.useJsonView";
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      final retrievedValue = prefs.getBool(key);
      setState(() {
        isEnabled = retrievedValue ?? false;
      });
    });
  }

  void setValue(bool newValue) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(key, newValue);
      setState(() {
        isEnabled = newValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("JSON model messages"),
      subtitle: const Text("View the model's messages in raw unparsed JSON"),
      trailing: Switch.adaptive(value: isEnabled, onChanged: setValue),
    );
  }
}
