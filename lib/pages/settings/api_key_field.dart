import 'package:coms/classes/gemini/gemini_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyField extends StatefulWidget {
  const ApiKeyField({
    super.key,
  });

  @override
  State<ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<ApiKeyField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) =>
        {_controller.text = prefs.getString("gemini_api_key") ?? ""});
    super.initState();
  }

  void applyKey(GeminiProvider geminiProvider) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("gemini_api_key", _controller.text);
    geminiProvider.setApiKey(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final geminiProvider = Provider.of<GeminiProvider>(context);
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () => applyKey(geminiProvider),
            icon: const Icon(Icons.save)),
        label: const Text("API Key"),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
