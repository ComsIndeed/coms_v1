import 'dart:convert';

import 'package:coms/classes/widgetList/widget_serialization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetMapProvider with ChangeNotifier {
  Map<String, Widget> _widgetMap = {};
  Map<String, Widget> get widgetMap => Map.unmodifiable(_widgetMap);
  List<Widget> get widgetList => List.unmodifiable(_widgetMap.values);
  Map<String, dynamic> _serializedWidgetMap = {};
  Map<String, dynamic> get serializedWidgetMap =>
      Map.unmodifiable(_serializedWidgetMap);
  List<dynamic> get serializedWidgetList =>
      List.unmodifiable(serializedWidgetMap.values);

  static const _widgetPreferenceKey = "widgets";

  WidgetMapProvider() {
    SharedPreferences.getInstance().then((prefs) {
      final encodedSerializedWidgetMap =
          prefs.getString(_widgetPreferenceKey) ?? "{}";
      final Map<String, dynamic> serializedWidgetMap =
          jsonDecode(encodedSerializedWidgetMap);

      Map<String, Widget> widgetMap = {};
      for (final key in serializedWidgetMap.keys) {
        widgetMap[key] =
            WidgetSerialization.toWidget(jsonEncode(serializedWidgetMap[key]));
      }

      _serializedWidgetMap = serializedWidgetMap;
      _widgetMap = widgetMap;
    }).catchError((e, s) {
      Fluttertoast.showToast(msg: "$e, $s");
    });
  }

  void refresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedSerializedWidgetMap =
          prefs.getString(_widgetPreferenceKey) ?? "{}";
      final Map<String, dynamic> serializedWidgetMap =
          jsonDecode(encodedSerializedWidgetMap);

      Map<String, Widget> widgetMap = {};
      for (final key in serializedWidgetMap.keys) {
        widgetMap[key] =
            WidgetSerialization.toWidget(jsonEncode(serializedWidgetMap[key]));
      }

      _widgetMap = widgetMap;
      _serializedWidgetMap = serializedWidgetMap;
      notifyListeners();
    } catch (e, s) {
      Fluttertoast.showToast(msg: "$e, $s");
      throw Exception("$e, $s");
    }
  }

  void addWidget(String serializedWidget) {
    final decodedSerializedWidget = jsonDecode(serializedWidget);
    final id = decodedSerializedWidget["params"]["id"];

    if (id == null) throw Exception("ID is null");

    _widgetMap[id] = WidgetSerialization.toWidget(serializedWidget);
    _serializedWidgetMap[id] = decodedSerializedWidget;
    notifyListeners();

    WidgetSerialization.addToPrefs(serializedWidget,
        prefsKey: _widgetPreferenceKey);
  }

  void removeWidget(String id) {
    _widgetMap.remove(id);
    _serializedWidgetMap.remove(id);
    notifyListeners();

    WidgetSerialization.removeFromPrefs(id, prefsKey: _widgetPreferenceKey);
  }

  void clear() {
    final initialCount = _widgetMap.entries.length;
    _widgetMap.clear();
    _serializedWidgetMap.clear();
    notifyListeners();
    Fluttertoast.showToast(msg: "Removed $initialCount widgets");

    WidgetSerialization.clearPrefs(prefsKey: _widgetPreferenceKey);
  }
}
