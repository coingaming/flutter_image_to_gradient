import 'package:flutter/material.dart';

class ImgProcessorConfig {
  final int targetImageSize;
  final int numberOfClusters;
  final int sampleRate;
  final List<Color> ignoredColors;

  const ImgProcessorConfig({
    this.targetImageSize = 200,
    this.numberOfClusters = 35,
    this.sampleRate = 1,
    this.ignoredColors = const [Colors.white, Colors.black],
  });
}
