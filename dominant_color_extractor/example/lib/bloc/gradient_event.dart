import 'dart:typed_data';
import 'package:flutter/material.dart';

sealed class GradientEvent {}

class ExtractFromUrl extends GradientEvent {
  final String url;
  ExtractFromUrl(this.url);
}

class ExtractFromGallery extends GradientEvent {}

class ExtractFromAsset extends GradientEvent {
  final String assetPath;
  ExtractFromAsset(this.assetPath);
}

class ExtractColorsFromImage extends GradientEvent {
  final Uint8List imageBytes;
  ExtractColorsFromImage(this.imageBytes);
}

class GenerateGradient extends GradientEvent {
  final List<Color> colors;
  GenerateGradient(this.colors);
}
