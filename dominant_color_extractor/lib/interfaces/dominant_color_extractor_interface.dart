import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract interface class DominantColorExtractorInterface {
  Future<List<Color>> extractColors({required Uint8List imageBytes});
}
