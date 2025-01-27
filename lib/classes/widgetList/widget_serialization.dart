import 'dart:convert';
import 'package:coms/classes/widgetList/widgets/note_widget/note_widget.dart';
import 'package:coms/classes/widgetList/widgets/reminder_widget/reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSerialization {
  WidgetSerialization._();

  // Handles building persisted serialized widgets from prefs
  /// !!! HERE ======================================================
  /// !!! HERE =========== ADD NEW WIDGETS HERE =====================
  /// !!! HERE ======================================================
  static final Map<String, Widget Function(Map<String, dynamic>)>
      widgetMapping = {
    "note_widget": (params) => NoteWidget.fromJson(params),
    "reminder_widget": (params) => ReminderWidget.fromJson(params),
  };

  /// !!! HERE ======================================================

  static Widget toWidget(String serializedWidget) {
    final decodedSerializedWidget = jsonDecode(serializedWidget);
    final key = decodedSerializedWidget["key"];
    final params = decodedSerializedWidget["params"];

    if (widgetMapping[key] == null) {
      throw Exception("Widget with key $key does not exist");
    }

    final widget = widgetMapping[key]!(params);
    return widget;
  }

  static void addToPrefs(String serializedWidget,
      {required String prefsKey}) async {
    final Map<String, dynamic> decodedSerializedWidget =
        jsonDecode(serializedWidget);
    final id = decodedSerializedWidget["params"]["id"];

    final prefs = await SharedPreferences.getInstance();
    final encodedSerializedWidgetMap = prefs.getString(prefsKey) ?? "{}";
    final serializedWidgetMap = jsonDecode(encodedSerializedWidgetMap);
    serializedWidgetMap[id] = decodedSerializedWidget;
    final newSerializedWidgetMap = jsonEncode(serializedWidgetMap);
    prefs.setString(prefsKey, newSerializedWidgetMap);
  }

  static void removeFromPrefs(String id, {required String prefsKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSerializedWidgetMap = prefs.getString(prefsKey) ?? "{}";
    final Map<String, dynamic> serializedWidgetMap =
        jsonDecode(encodedSerializedWidgetMap);
    serializedWidgetMap.remove(id);
    final newSerializedWidgetMap = jsonEncode(serializedWidgetMap);
    prefs.setString(prefsKey, newSerializedWidgetMap);
  }

  static void replaceFromPrefs(String id, Map<String, dynamic> serializedWidget,
      {required String prefsKey}) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSerializedWidgetMap = prefs.getString(prefsKey) ?? "{}";
    final Map<String, dynamic> serializedWidgetMap =
        jsonDecode(encodedSerializedWidgetMap);
    serializedWidgetMap[id] = serializedWidget;
    final newSerializedWidgetMap = jsonEncode(serializedWidgetMap);
    prefs.setString(prefsKey, newSerializedWidgetMap);
  }

  static void clearPrefs({required String prefsKey}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsKey, "{}");
  }
}
