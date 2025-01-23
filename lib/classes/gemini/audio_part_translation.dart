import 'package:google_generative_ai/google_generative_ai.dart';

class AudioPartTranslation {
  // Images are DataParts, Audios are FileParts
  static const String prompt =
      "Transcribe the dialogues exactly as is. Label each dialogue with who said what, use context clues. Include backgroud noises in the transcription if relevant. Immediately provide the transcriptions, no intro or outro texts, your response must purely only be the actual content itself.";

  static Future<TextPart> runTranscriber(
      {required FilePart filePart,
      required String apiKey,
      String? modelName}) async {
    final model = GenerativeModel(
      model: modelName ?? "gemini-1.5-flash",
      apiKey: apiKey,
      systemInstruction: Content.system(
        prompt,
      ),
    );

    final chat = model.startChat();

    final response = await chat.sendMessage(Content(
        "user", [TextPart("Please transcribe the following: "), filePart]));

    return TextPart(
        "[SYSTEM AUTO-GENERATED TRANSCRIPTION OF PROVIDED AUDIO:\n${response.text ?? "NO TRANSCRIPTION"}\n]");
  }
}
