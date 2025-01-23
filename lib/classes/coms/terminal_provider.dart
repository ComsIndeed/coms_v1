import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminalProvider with ChangeNotifier {
  late List<String> _terminalHistory = [];
  List<String> get history => _terminalHistory;
  final SharedPreferences prefs;

  TerminalProvider(this.prefs) {
    final retrievedHistory = prefs.getStringList("terminal_history") ?? [];
    _terminalHistory = retrievedHistory;
    if (_terminalHistory.isEmpty) {
      _terminalHistory.add("Basic terminal 1.0");
    }
  }

  add(String text) {
    _terminalHistory.add(text);
    notifyListeners();
    prefs.setStringList("terminal_history", _terminalHistory);
  }

  remove(int index) {
    _terminalHistory.removeAt(index);
    notifyListeners();
    prefs.setStringList("terminal_history", _terminalHistory);
  }

  clear() {
    _terminalHistory.clear();
    _terminalHistory.add("Basic terminal 1.0");
    notifyListeners();
    prefs.setStringList("terminal_history", _terminalHistory);
  }
}
