import 'dart:io';

import 'package:coms/classes/gemini/attachment/audio_attachment_widget.dart';
import 'package:coms/classes/gemini/create_audio_part.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Attachment {
  final String label;
  final MediaType type;
  final String? apiKey;
  late Uri? uri;
  late String? path;

  Attachment(
      {required this.label,
      required this.type,
      this.apiKey,
      this.uri,
      this.path});

  Future<Part> asPart() async {
    if (type == MediaType.audio) {
      if (uri != null) {
        final audioPart = FilePart(uri!);
        return audioPart;
      }
      if (path != null) {
        if (apiKey == null) {
          throw Exception("No api key provided");
        }
        final audioPart = await createAudioPart(path: path!, apiKey: apiKey!);
        return audioPart;
      }
      throw Exception("Uri or Path must be provided");
    }

    if (type == MediaType.image) {
      if (path != null) {
        final imageBytes = await File(path!).readAsBytes();
        final imagePart = DataPart("image/jpeg", imageBytes);
        return imagePart;
      }
      throw Exception("A path must be provided");
    }

    throw Exception("Attachment is of type ${type.runtimeType.toString()}");
  }

  Widget asWidget(Function(Attachment) onDelete, {int? index}) {
    if (type == MediaType.audio) {
      return AudioAttachmentWidget(onDelete: onDelete, attachment: this);
    }

    if (type == MediaType.image) {
      return const ListTile(
        title: Text("Audio"),
      );
    }
    return ListTile(
      title: Text(label),
      subtitle: Text(type == MediaType.audio ? "Audio" : "Image"),
      trailing: IconButton(
        onPressed: () => onDelete(this),
        icon: const Icon(Icons.clear),
      ),
    );
  }
}

enum MediaType { audio, image }
