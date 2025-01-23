import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiProvider with ChangeNotifier {
  String? apiKey;

  GeminiProvider({this.apiKey});

  GenerativeModel getModel(
      {required String modelName,
      GenerationConfig? generationConfig,
      String? systemInstructions,
      List<Tool>? tools}) {
    apiKey == null ? throw Exception("No api key set: $apiKey") : null;
    return GenerativeModel(
      model: modelName,
      apiKey: apiKey!,
      generationConfig: generationConfig,
      tools: tools,
      systemInstruction: systemInstructions != null
          ? Content.system(systemInstructions)
          : null,
    );
  }

  void setApiKey(String apiKey) {
    this.apiKey = apiKey;
    notifyListeners();
  }
}
