import 'package:flutter/material.dart';

class ImgProcessorConfig {
  static const int _defaultImageSize = 200;
  static const int _numberOfClusters = 35;
  static const int _sampleRate = 1;

  final int targetImageSize;
  final int numberOfClusters;
  final int sampleRate;
  final List<Color> ignoredColors;

  const ImgProcessorConfig({
    this.targetImageSize = _defaultImageSize,
    this.numberOfClusters = _numberOfClusters,
    this.sampleRate = _sampleRate,
    this.ignoredColors = const [Colors.white, Colors.black],
  });
}
