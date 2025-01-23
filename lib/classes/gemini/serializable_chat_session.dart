import 'dart:convert';

import 'package:coms/classes/gemini/audio_part_translation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'mutex.dart';

class SerializableChatSession with ChangeNotifier {
  final _mutex = Mutex();
  late List<Content> _history;
  bool isProcessing = false;

  SerializableChatSession({List<Content>? history}) {
    _history = history ?? [];
  }

  List<Content> get history => List.unmodifiable(_history);

  void clearHistory() {
    _history = [];
    notifyListeners();
  }

  String get serializedHistory {
    final contentJsons = _history.map((content) {
      final textMessage = content.parts
          .whereType<TextPart>()
          .map((textPart) => textPart.text)
          .join("\n\n");
      Map<String, String> contentJson = {
        "role": content.role ?? "No role",
        "text": textMessage
      };
      return contentJson;
    });

    final encodedContentJsons = jsonEncode(contentJsons.toList());
    return encodedContentJsons;
  }

  static List<Content> _getDeserializedHistory(String serializedHistory) {
    final List<dynamic> contentJsons = jsonDecode(serializedHistory);
    final List<Content> history = contentJsons.map((contentJson) {
      return Content(contentJson["role"]!, [TextPart(contentJson["text"]!)]);
    }).toList();
    return history;
  }

  static SerializableChatSession fromSerializedHistory(
      String serializedHistory) {
    final history = _getDeserializedHistory(serializedHistory);
    return SerializableChatSession(history: history);
  }

  Future<GenerateContentResponse> sendMessage(
      {required GenerativeModel model,
      required Content message,
      required String apiKey}) async {
    final lock = await _mutex.acquire();
    try {
      _history.add(message);
      isProcessing = true;
      notifyListeners();

      final fileParts = message.parts.whereType<FilePart>();
      final textParts = message.parts.whereType<TextPart>();

      if (fileParts.isEmpty) {
        final response =
            await model.generateContent(_history.followedBy([message]));
        final modelMessage = Content("model",
            [TextPart(response.text ?? "ERROR: response.text is null")]);
        _history.add(modelMessage);
        notifyListeners();
        return response;
      }

      if (fileParts.isNotEmpty) {
        final Iterable<Future<TextPart>> filePartTranscriptionFutures =
            fileParts.map((filePart) {
          return AudioPartTranslation.runTranscriber(
              filePart: filePart, apiKey: apiKey);
        });

        final responses = await Future.wait([
          model.generateContent(_history.followedBy([message])),
          Future.wait(filePartTranscriptionFutures),
        ]);

        final inferenceResponse =
            responses.elementAt(0) as GenerateContentResponse;
        final filePartTranscriptions =
            responses.elementAt(1) as Iterable<TextPart>;

        final textPart =
            textParts.map((textPart) => textPart.text).join("\n\n");

        final dataPartAsTextParts = filePartTranscriptions
            .map((filePartTranscription) => filePartTranscription.text)
            .join("\n\n");

        final transcribedContent =
            Content.text("$textPart\n\n$dataPartAsTextParts");
        _history.removeLast();
        _history.add(transcribedContent);
        _history
            .add(Content("model", [TextPart(inferenceResponse.text ?? "")]));
        isProcessing = false;
        notifyListeners();
        return inferenceResponse;
      } else {
        throw Exception("fileParts is neither empty nor not empty. What.");
      }
    } catch (e) {
      _history.remove(message);
      isProcessing = false;
      notifyListeners();
      throw Exception("Error: $e");
    } finally {
      lock.release();
    }
  }
}
