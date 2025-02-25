import 'package:flutter/material.dart';

class DominantColorModel {
  final List<Color> colors;

  DominantColorModel({required this.colors});

  factory DominantColorModel.fromSingleColor(Color color) {
    return DominantColorModel(colors: [color]);
  }
}
