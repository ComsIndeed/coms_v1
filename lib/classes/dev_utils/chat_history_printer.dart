import 'package:google_generative_ai/google_generative_ai.dart';

class ChatHistoryPrinter {
  List<Content> chatHistory;

  ChatHistoryPrinter(this.chatHistory);

  void printValues() {
    print("History length: ${chatHistory.length}");
    for (final content in chatHistory) {
      List<String> parts = [];
      for (final part in content.parts) {
        if (part is TextPart) {
          parts.add(part.text);
          break;
        }
        throw Exception("Not a textpart: ${part.runtimeType.toString()}");
      }
      print("============== ${content.role} ================");
      parts.forEach(print);
    }
  }
}
