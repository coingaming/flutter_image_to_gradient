import 'package:flutter/material.dart';

class DominantColorExtractorConfig {
  final int targetImageSize;
  final int numberOfClusters;
  final int sampleRate;
  final List<Color> ignoredColors;

  const DominantColorExtractorConfig({
    this.targetImageSize = 200,
    this.numberOfClusters = 35,
    this.sampleRate = 1,
    this.ignoredColors = const [Colors.white, Colors.black],
  });
}
