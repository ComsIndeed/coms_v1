import 'package:coms/classes/gemini/serializable_chat_session.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainConversationProvider with ChangeNotifier {
  late SerializableChatSession serializableChatSession;
  final SharedPreferences sharedPreferences;
  static const key = "MainConversationProvider.serializableChatSession";

  MainConversationProvider({required this.sharedPreferences}) {
    final retrievedHistory = sharedPreferences.getString(key);
    if (retrievedHistory != null) {
      serializableChatSession =
          SerializableChatSession.fromSerializedHistory(retrievedHistory);
    } else {
      serializableChatSession = SerializableChatSession();
    }
  }

  void clearHistory() {
    sharedPreferences.remove(key);
    serializableChatSession.clearHistory();
    notifyListeners();

    Fluttertoast.showToast(
        msg: "Removed ${serializableChatSession.history.length} messages");
  }

  void notifyChanges() {
    notifyListeners();
  }

  void saveChanges() {
    sharedPreferences.setString(key, serializableChatSession.serializedHistory);
  }
}
