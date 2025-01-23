import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:coms/classes/gemini/attachment/attachment.dart';
import 'package:flutter/material.dart';

class AudioAttachmentWidget extends StatefulWidget {
  final int? index;
  final Function(Attachment) onDelete;
  final Attachment attachment;

  const AudioAttachmentWidget(
      {super.key,
      this.index,
      required this.onDelete,
      required this.attachment});

  @override
  State<AudioAttachmentWidget> createState() => _AudioAttachmentWidgetState();
}

class _AudioAttachmentWidgetState extends State<AudioAttachmentWidget> {
  final playerController = PlayerController();
  bool isPlaying = false;

  final style = const PlayerWaveStyle(
    backgroundColor: Colors.black,
    waveThickness: 1.5,
    spacing: 3,
    scaleFactor: 130,
  );

  @override
  Widget build(BuildContext context) {
    final samples =
        style.getSamplesForWidth(MediaQuery.of(context).size.width * 0.5);

    playerController.preparePlayer(
        path: widget.attachment.path ?? "", noOfSamples: samples);
    playerController.setFinishMode(finishMode: FinishMode.pause);

    playerController.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state.isPlaying;
      });
    });

    return ListTile(
      title: AudioFileWaveforms(
        size: const Size(400, 50),
        playerController: playerController,
        waveformType: WaveformType.fitWidth,
        playerWaveStyle: style,
      ),
      key: widget.index != null ? Key(widget.index.toString()) : null,
      leading: isPlaying
          ? IconButton.filledTonal(
              onPressed: () => playerController.stopPlayer(),
              icon: const Icon(Icons.stop))
          : IconButton.filledTonal(
              onPressed: () => playerController.startPlayer(),
              icon: const Icon(Icons.play_arrow)),
      trailing: IconButton(
        onPressed: () => widget.onDelete(widget.attachment),
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
