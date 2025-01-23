import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:coms/pages/homepage/homepage_action.dart';
import 'package:coms/pages/homepage/input_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification Permission"),
          content: const Text(
            "We need notification permissions to send your reminders and alarms.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Navigate to settings or request permissions here
                Navigator.of(context).pop(); // Close the dialog
                AwesomeNotifications().requestPermissionToSendNotifications();
              },
              child: const Text("Enable"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgetMapProvider = Provider.of<WidgetMapProvider>(context);
    final widgetList = widgetMapProvider.widgetList;

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showPermissionDialog(context);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const HomepageAction(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment(0, 0.7),
                    colors: [Colors.transparent, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 96.0),
                    child: Column(
                      children: [...widgetList]
                          .animate(interval: 200.ms)
                          .fadeIn(duration: 200.ms),
                    ),
                  ),
                ),
              ),
            )),
            const InputInterface()
          ],
        ),
      ),
    );
  }
}
