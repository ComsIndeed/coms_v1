import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshWidgetsTile extends StatelessWidget {
  const RefreshWidgetsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetMapProvider = Provider.of<WidgetMapProvider>(context);

    return ListTile(
      title: const Text("Refresh widgets"),
      subtitle: const Text("Refreshes the homepage widgets list"),
      trailing: IconButton(
          onPressed: widgetMapProvider.refresh,
          icon: const Icon(Icons.refresh)),
    );
  }
}
