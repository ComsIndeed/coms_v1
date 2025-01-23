import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class WaveformFull extends StatelessWidget {
  final RecorderController controller;

  const WaveformFull({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0),
          alignment: Alignment.center,
          child: WaveformHalf(controller: controller),
        ),
        WaveformHalf(controller: controller),
      ],
    );
  }
}

class WaveformHalf extends StatelessWidget {
  final RecorderController controller;

  const WaveformHalf({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      size: Size(MediaQuery.of(context).size.width * 0.3, 70),
      recorderController: controller,
      waveStyle: const WaveStyle(
        backgroundColor: Colors.black,
        waveColor: Colors.white,
        extendWaveform: true,
        waveThickness: 6,
        spacing: 10,
        showMiddleLine: false,
        scaleFactor: 70,
      ),
    );
  }
}
