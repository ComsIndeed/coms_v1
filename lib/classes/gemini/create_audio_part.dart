import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

Future<FilePart> createAudioPart(
    {required String path, required String apiKey}) async {
  Future<String> uploadAudio({
    required String audioPath,
    required String apiKey,
  }) async {
    final fileBytes = await File(audioPath).readAsBytes();

    final startResponse = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/upload/v1beta/files?key=$apiKey'),
      headers: {
        'X-Goog-Upload-Protocol': 'resumable',
        'X-Goog-Upload-Command': 'start',
        'Content-Type': 'application/json',
        'X-Goog-Upload-Header-Content-Type': 'audio/mp3',
        'X-Goog-Upload-Header-Content-Length': '${fileBytes.length}',
      },
    );
    final uploadUrl = startResponse.headers['x-goog-upload-url'];
    if (uploadUrl == null) throw Exception("UPLOAD URL IS NULL: $uploadUrl");

    final uploadResponse = await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'X-Goog-Upload-Command': 'upload, finalize',
        'X-Goog-Upload-Offset': '0',
        'Content-Length': '${fileBytes.length}',
        'Content-Type': 'audio/mp3',
      },
      body: fileBytes,
    );
    if (uploadResponse.statusCode != 200) {
      throw Exception(
          'Failed to upload file: ${uploadResponse.statusCode}, ${uploadResponse.body}');
    }

    final metadata = jsonDecode(uploadResponse.body);
    final fileUri = metadata['file']['uri'];
    return fileUri;
  }

  final audioUri = await uploadAudio(audioPath: path, apiKey: apiKey);
  final filePart = FilePart(Uri.parse(audioUri));
  return filePart;
}
