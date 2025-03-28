import 'package:flutter/material.dart';

class ImgProcessorConfig {
  static const int _defaultImageSize = 200;
  static const int _defaultNumberOfClusters = 35;
  static const int _defaultSampleRate = 1;

  final int targetImageSize;
  final int numberOfClusters;
  final int sampleRate;
  final List<Color> ignoredColors;

  const ImgProcessorConfig({
    this.targetImageSize = _defaultImageSize,
    this.numberOfClusters = _defaultNumberOfClusters,
    this.sampleRate = _defaultSampleRate,
    this.ignoredColors = const [Colors.white, Colors.black],
  });
}
