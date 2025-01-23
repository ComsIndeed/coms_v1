import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:coms/classes/gemini/attachment/attachment.dart';
import 'package:coms/classes/gemini/gemini_provider.dart';
import 'package:coms/pages/homepage/waveform.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class MicButton extends StatefulWidget {
  final Function(Attachment) addAttachment;

  const MicButton({
    super.key,
    required this.addAttachment,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool isRecording = false;
  final recorderController = RecorderController();

  void toggleRecording(String? apiKey) async {
    if (apiKey == null) throw Exception("Please provide an API key");

    try {
      if (!isRecording) {
        // Start recording
        setState(() {
          isRecording = true;
        });

        await recorderController.record(bitRate: 320);

        if (!recorderController.isRecording) throw Exception("Error start");
      } else {
        // Stop recording
        setState(() {
          isRecording = false;
        });

        final recordingPath = await recorderController.stop();

        if (recordingPath == null) throw Exception("Recording path is null");

        final recordingAttachment = Attachment(
            label: path.basename(recordingPath),
            path: recordingPath,
            type: MediaType.audio,
            apiKey: apiKey);

        widget.addAttachment(recordingAttachment);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      if (recorderController.isRecording) await recorderController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetWidth = MediaQuery.of(context).size.width;
    final geminiProvider = Provider.of<GeminiProvider>(context);
    recorderController.updateFrequency = const Duration(milliseconds: 10);

    return AnimatedContainer(
      width: isRecording ? widgetWidth * 0.6 : 100,
      height: isRecording ? 60 : 45,
      curve: Curves.easeInOutBack,
      duration: Durations.long2,
      child: ElevatedButton(
        onPressed: () => toggleRecording(geminiProvider.apiKey),
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary),
        child: AnimatedSwitcher(
          duration: Durations.long4,
          child: !isRecording
              ? const Icon(Icons.mic)
              : FittedBox(
                  child: WaveformFull(controller: recorderController),
                ),
        ),
      ),
    );
  }
}
