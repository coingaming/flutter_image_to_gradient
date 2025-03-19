import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract class IColorExtractor {
  Future<List<Color>> extractColors({required Uint8List imageBytes});
}
