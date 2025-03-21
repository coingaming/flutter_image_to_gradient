import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';

class ImageColorExtractorImpl implements ColorExtractorInterface {
  final _colorExtractor = DominantColorExtractor();
  final _cache = <int, List<Color>>{};

  @override
  Future<List<Color>> extractColors({required Uint8List imageBytes}) async {
    final key = imageBytes.hashCode;

    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final colors =
          await _colorExtractor.extractColors(imageBytes: imageBytes);
      _cache[key] = colors;
      return colors;
    } catch (_) {
      return [Colors.grey];
    }
  }
}
