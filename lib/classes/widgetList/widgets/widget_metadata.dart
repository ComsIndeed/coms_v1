import 'package:flutter/material.dart';

class WidgetMetadata with ChangeNotifier {
  late DateTime createdAt;
  late DateTime lastModified;
  DateTime? lastSynced;

  WidgetMetadata._() {
    createdAt = DateTime.now().toLocal();
    lastModified = DateTime.now().toLocal();
  }
  static WidgetMetadata create() {
    return WidgetMetadata._();
  }

  void triggerModified() {
    lastModified = DateTime.now().toLocal();
    notifyListeners();
  }

  void triggerSynced() {
    lastSynced = DateTime.now().toLocal();
    notifyListeners();
  }
}
