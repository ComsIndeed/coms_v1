import 'dart:convert';

import 'package:coms/classes/coms/firebase/firebase_provider.dart';
import 'package:coms/classes/coms/terminal_provider.dart';
import 'package:coms/classes/widgetList/widget_map_provider.dart';
import 'package:coms/classes/widgetList/widget_serialization.dart';
import 'package:coms/main_app.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class WidgetSynchronization {
  final WidgetMapProvider _widgetMapProvider;
  final FirebaseProvider _firebaseProvider;

  WidgetSynchronization(this._widgetMapProvider, this._firebaseProvider);

  String getWidgetPayload() {
    final serializedWidgetMap = _widgetMapProvider.serializedWidgetMap;
    final serializedWidgetArchiveMap =
        _widgetMapProvider.serializedWidgetArchiveMap;

    final Map<String, dynamic> payload = {
      'widgetMap': serializedWidgetMap,
      'widgetArchiveMap': serializedWidgetArchiveMap
    };

    final encodedPayload = jsonEncode(payload);
    return encodedPayload;
  }

  Future<Map<String, Widget>> fetchWidgets() async {
    try {
      final response = await _firebaseProvider.userDocument.get();
      final data = response.data() as Map<String, dynamic>?;

      if (data == null) throw Exception("Fetched data is null");

      final widgetsField = jsonDecode(data["widgets"]);

      Provider.of<TerminalProvider>(navigatorKey.currentContext!, listen: false)
          .add("$widgetsField");

      final Map<String, dynamic> serializedWidgetMap =
          widgetsField["widgetMap"];
      Map<String, Widget> widgetMap = {};
      for (var serializedWidgetKey in serializedWidgetMap.keys) {
        final serializedWidget = serializedWidgetMap[serializedWidgetKey];
        final encodedSerializedWidget = jsonEncode(serializedWidget);
        final id = serializedWidget["params"]["id"];
        final Widget widget =
            WidgetSerialization.toWidget(encodedSerializedWidget);

        widgetMap[id] = widget;
      }

      return widgetMap;
    } catch (e, s) {
      Provider.of<TerminalProvider>(navigatorKey.currentContext!, listen: false)
          .add("$e, $s");
      Fluttertoast.showToast(msg: "$e");

      return {};
    }
  }

  Future<void> uploadWidgets() async {
    final payload = getWidgetPayload();

    await _firebaseProvider.userDocument.set({"widgets": payload});
  }
}


///
///   Firestore Schema
///     
///     /root
///       /users
///         /:uid
///           /widgets (json string) // Json representation of all the widgets (including archives) in a single 
///
///