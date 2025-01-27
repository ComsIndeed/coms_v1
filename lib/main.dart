import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coms/classes/coms/actions_handler.dart';
import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:coms/classes/coms/firebase/widget_synchronization.dart';
import 'package:coms/classes/coms/main_conversation_provider.dart';
import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:coms/classes/files/app_directory.dart';
import 'package:coms/classes/gemini/gemini_provider.dart';
import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widget_serialization.dart';
import 'package:coms/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDisplayMode.setHighRefreshRate();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final widgetMapProvider = WidgetMapProvider();

  final firebaseProvider = FirebaseProvider();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'reminders',
          channelName: 'Reminders',
          channelDescription: 'Notification channel for scheduled reminders',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
        NotificationChannel(
          channelKey: 'dev',
          channelName: 'DEV',
          channelDescription:
              'Notification channel for development and debugging purposes',
          defaultColor: const Color.fromARGB(255, 221, 80, 80),
          ledColor: Colors.white,
        ),
      ],
      debug: true);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => widgetMapProvider,
      ),
      ChangeNotifierProvider(
        create: (context) => AppDirectoryProvider.initialize(),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            GeminiProvider(apiKey: prefs.getString("gemini_api_key")),
      ),
      ChangeNotifierProvider(
        create: (context) => MainConversationProvider(sharedPreferences: prefs),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            ActionsHandler(widgetMapProvider: widgetMapProvider),
      ),
      ChangeNotifierProvider(
        create: (context) => TerminalProvider(prefs),
      ),
      ChangeNotifierProvider(
        create: (context) => firebaseProvider,
      ),
      Provider(
        create: (context) =>
            WidgetSynchronization(widgetMapProvider, firebaseProvider),
      )
    ],
    child: const MainApp(),
  ));
}
