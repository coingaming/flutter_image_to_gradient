import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DominantColorModel extends Equatable {
  final List<Color> colors;

  DominantColorModel({required this.colors});

  @override
  List<Object> get props => [Color];

  factory DominantColorModel.fromSingleColor(Color color) {
    return DominantColorModel(colors: [color]);
  }
}
