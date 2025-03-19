import 'dart:typed_data';

import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';

import '../../interfaces/color_extractor_interface.dart';

class ImageColorExtractorImpl implements IColorExtractor {
  @override
  Future<List<Color>> extractColors({required Uint8List imageBytes}) async {
    return await DominantColorExtractor.extractColors(
        existingImageBytes: imageBytes);
  }
}
