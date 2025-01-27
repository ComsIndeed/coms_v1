import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBlock extends StatelessWidget {
  final String text;
  const CodeBlock(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Clipboard.setData(ClipboardData(text: text)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ID: $text"),
          const Icon(Icons.copy),
        ],
      ),
    );
  }
}
