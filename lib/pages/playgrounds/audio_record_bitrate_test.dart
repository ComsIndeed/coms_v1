import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AudioRecordBitrateTest extends StatefulWidget {
  const AudioRecordBitrateTest({super.key});

  @override
  State<AudioRecordBitrateTest> createState() => _AudioRecordBitrateTestState();
}

class _AudioRecordBitrateTestState extends State<AudioRecordBitrateTest> {
  final textEditingController = TextEditingController();
  final audioRecordingController = RecorderController();
  final playerController = PlayerController();
  String? recordingPath;
  bool isRecording = false;
  bool isPlaying = false;
  int currentBitrate = 128;

  Future<void> record() async {
    if (isRecording) {
      try {
        final path = await audioRecordingController.stop();
        setState(() {
          recordingPath = path;
          isRecording = false;
        });
      } catch (e, s) {
        setState(() => isRecording = false);
        Fluttertoast.showToast(msg: "$e, $s");
      }
    } else {
      try {
        await audioRecordingController.record(bitRate: currentBitrate);
        setState(() => isRecording = true);
      } catch (e, s) {
        setState(() => isRecording = false);
        Fluttertoast.showToast(msg: "$e, $s");
      }
    }
  }

  Future<void> play() async {
    if (recordingPath == null) return;
    if (isPlaying) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = currentBitrate.toString();
    playerController.onCompletion.listen((_) {
      setState(() => isPlaying = false);
    });
  }

  void increment() => setState(() {
        currentBitrate += 10;
        textEditingController.text = currentBitrate.toString();
      });

  void decrement() => setState(() {
        if (currentBitrate > 10) {
          currentBitrate -= 10;
          textEditingController.text = currentBitrate.toString();
        }
      });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Bitrate Test"),
      subtitle: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: increment, icon: const Icon(Icons.add)),
              IconButton(onPressed: decrement, icon: const Icon(Icons.remove)),
            ],
          ),
        ),
        keyboardType: TextInputType.number,
      ),
      trailing: IconButton(
        onPressed: record,
        icon: Icon(isRecording ? Icons.stop : Icons.mic),
      ),
      children: [
        if (recordingPath != null) ...[
          Row(
            children: [
              IconButton(
                onPressed: play,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              Expanded(
                child: AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width * 0.8, 30),
                  playerController: playerController,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    audioRecordingController.dispose();
    playerController.dispose();
    super.dispose();
  }
}
