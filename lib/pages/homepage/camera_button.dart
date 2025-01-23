import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({
    super.key,
  });

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  final recorderController = RecorderController();

  void startRecording() async {
    await recorderController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
        onPressed: () {
          startRecording();
        },
        icon: const Icon(Icons.camera_alt));
  }
}
