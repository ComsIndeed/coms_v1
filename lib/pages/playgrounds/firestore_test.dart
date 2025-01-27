import 'package:colorful_iconify_flutter/icons/vscode_icons.dart';
import 'package:coms/classes/coms/firebase/widget_synchronization.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';

class FirestoreTest extends StatefulWidget {
  const FirestoreTest({
    super.key,
  });

  @override
  State<FirestoreTest> createState() => _FirestoreTestState();
}

class _FirestoreTestState extends State<FirestoreTest> {
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    final widgetSynchronizationProvider =
        Provider.of<WidgetSynchronization>(context);

    return ExpansionTile(
      leading: const Iconify(VscodeIcons.file_type_firestore),
      title: const Text("Firestore test"),
      subtitle: const Text(
          "Uploads current widgets to user's Firestore document and refetches them. Expand to view fetched widgets."),
      trailing: TextButton(
          onPressed: () async {
            await widgetSynchronizationProvider.uploadWidgets();
            final fetchedWidgets =
                await widgetSynchronizationProvider.fetchWidgets();

            setState(() {
              widgets = fetchedWidgets.entries
                  .map((widgetEntry) => widgetEntry.value)
                  .toList();
            });
          },
          child: const Text("Upload")),
      children: widgets.followedBy([const Text("List ends here.")]).toList(),
    );
  }
}
