// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ActionQueue with ChangeNotifier {
//   final SharedPreferences _prefs;
//   static const prefsKey = "ActionQueue";

//   List<ActionQueueItem> connectivityQueue = [];
//   List<ActionQueueItem> localQueue = [];

//   // Constructor to initialize and load persisted data
//   ActionQueue(this._prefs) {
//     _loadFromPrefs();
//   }

//   // Load data from SharedPreferences
//   void _loadFromPrefs() {
//     final persisted = _prefs.getString(prefsKey);
//     if (persisted != null) {
//       try {
//         final decoded = jsonDecode(persisted) as Map<String, dynamic>;
//         connectivityQueue = (decoded['connectivityQueue'] as List<dynamic>)
//             .map((item) =>
//                 ActionQueueItem.fromJson(item as Map<String, dynamic>))
//             .toList();
//         localQueue = (decoded['localQueue'] as List<dynamic>)
//             .map((item) =>
//                 ActionQueueItem.fromJson(item as Map<String, dynamic>))
//             .toList();
//       } catch (e) {
//         debugPrint("Error loading ActionQueue from prefs: $e");
//       }
//     }
//   }

//   // Save current queue states to SharedPreferences
//   void saveToPrefs() {
//     final payload = {
//       'connectivityQueue':
//           connectivityQueue.map((item) => item.toJson()).toList(),
//       'localQueue': localQueue.map((item) => item.toJson()).toList(),
//     };
//     _prefs.setString(prefsKey, jsonEncode(payload));
//   }

//   // Add an item to a queue
//   void addToQueue(List<ActionQueueItem> queue, ActionQueueItem item) {
//     queue.add(item);
//     saveToPrefs();
//     notifyListeners();
//   }

//   // Remove an item from a queue
//   void removeFromQueue(List<ActionQueueItem> queue, ActionQueueItem item) {
//     queue.removeWhere(
//         (i) => i.action == item.action && _mapEqual(i.params, item.params));
//     saveToPrefs();
//     notifyListeners();
//   }

//   // Execute actions based on their type
//   Future<void> executeAction(ActionQueueItem item) async {
//     switch (item.type) {
//       case ActionType.immediate:
//         _executeImmediate(item);
//         break;
//       case ActionType.conditional:
//         await _executeConditional(item);
//         break;
//       case ActionType.awaited:
//         await _executeAwaited(item);
//         break;
//     }
//   }

//   void _executeImmediate(ActionQueueItem item) {
//     debugPrint("Executing immediate action: ${item.action}");
//     // Implement your immediate action logic here
//   }

//   Future<void> _executeConditional(ActionQueueItem item) async {
//     debugPrint("Waiting for condition: ${item.condition}");
//     while (!(await item.condition())) {
//       await Future.delayed(
//           const Duration(milliseconds: 500)); // Check periodically
//     }
//     debugPrint("Condition met. Executing action: ${item.action}");
//     // Implement action logic here
//   }

//   Future<void> _executeAwaited(ActionQueueItem item) async {
//     debugPrint("Waiting for dependency: ${item.awaitKey}");
//     while (!_prefs.containsKey(item.awaitKey)) {
//       await Future.delayed(
//           const Duration(milliseconds: 500)); // Check periodically
//     }
//     debugPrint("Dependency resolved. Executing action: ${item.action}");
//     // Implement action logic here
//   }

//   // Helper: Compare two maps for equality
//   bool _mapEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
//     return MapEquality().equals(a, b);
//   }
// }

// enum ActionType { immediate, conditional, awaited }

// class ActionQueueItem {
//   String action;
//   ActionType type;
//   Map<String, dynamic> params;
//   String? awaitKey; // For awaited actions
//   Future<bool> Function()? condition; // For conditional actions

//   ActionQueueItem({
//     required this.action,
//     required this.type,
//     this.params = const {},
//     this.awaitKey,
//     this.condition,
//   });

//   // Serialize to JSON
//   Map<String, dynamic> toJson() => {
//         'action': action,
//         'type': type.index,
//         'params': params,
//         'awaitKey': awaitKey,
//       };

//   // Deserialize from JSON
//   factory ActionQueueItem.fromJson(Map<String, dynamic> json) {
//     return ActionQueueItem(
//       action: json['action'] as String,
//       type: ActionType.values[json['type'] as int],
//       params: json['params'] as Map<String, dynamic>? ?? {},
//       awaitKey: json['awaitKey'] as String?,
//     );
//   }
// }
