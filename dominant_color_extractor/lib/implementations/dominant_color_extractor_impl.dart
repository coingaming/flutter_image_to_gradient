import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';

class ImageColorExtractorImpl implements ColorExtractorInterface {
  final DominantColorExtractor _colorExtractor = DominantColorExtractor();

  @override
  Future<List<Color>> extractColors({required Uint8List imageBytes}) async {
    return await _colorExtractor.extractColors(imageBytes: imageBytes);
  }
}
