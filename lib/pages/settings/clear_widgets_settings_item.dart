import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClearWidgetsSettingsItem extends StatelessWidget {
  const ClearWidgetsSettingsItem({
    super.key,
  });

  // void deleteAll(WidgetMapProvider widgetMapProvider) {
  //   widgetMapProvider.widgetList.forEach((widget) => widgetMapProvider.removeWidget(widget))
  // }

  @override
  Widget build(BuildContext context) {
    final widgetMapProvider = Provider.of<WidgetMapProvider>(context);

    return ListTile(
      title: const Text("Clear widgets"),
      subtitle: const Text("Delete all existing widgets (IRREVERSIBLE)"),
      trailing: IconButton.filledTonal(
          style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 100, 0, 0)),
          onPressed: widgetMapProvider.clear,
          icon: const Icon(Icons.delete)),
    );
  }
}
