import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebSearchingToggle extends StatefulWidget {
  const WebSearchingToggle({
    super.key,
  });

  @override
  State<WebSearchingToggle> createState() => _WebSearchingToggleState();
}

class _WebSearchingToggleState extends State<WebSearchingToggle> {
  final String key = "settings.enableGrounding";
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
      title: const Text("Web Searching"),
      subtitle: const Text("Allow the model to browse the web for information"),
      trailing: Switch(value: isEnabled, onChanged: setValue),
    );
  }
}
