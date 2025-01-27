import 'package:colorful_iconify_flutter/icons/vscode_icons.dart';
import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';

class FirebaseInitialize extends StatelessWidget {
  const FirebaseInitialize({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

    return ListTile(
      leading: const Iconify(VscodeIcons.file_type_firebase),
      title: const Text("Initialize Firebase"),
      subtitle: const MarkdownBody(data: "Creates user document in Firestore"),
      trailing: TextButton(
          onPressed: firebaseProvider.reinitialize,
          child: const Text("Initialize")),
    );
  }
}
