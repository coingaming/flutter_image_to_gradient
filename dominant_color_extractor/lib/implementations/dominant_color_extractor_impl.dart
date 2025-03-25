import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';
import '../config/dominant_color_extractor.dart';

class DominantColorExtractorImpl implements DominantColorExtractorInterface {
  final _colorExtractor = DominantColorExtractor();
  final _cache = <int, List<Color>>{};
  final DominantColorExtractorConfig config;

  DominantColorExtractorImpl({
    this.config = const DominantColorExtractorConfig(),
  });

  @override
  Future<List<Color>> extractColors({required Uint8List imageBytes}) async {
    final key = imageBytes.hashCode;

    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final colors = await _colorExtractor.extractColors(
          imageBytes: imageBytes, config: config);
      _cache[key] = colors;
      return colors;
    } catch (_) {
      return [Colors.grey];
    }
  }
}
