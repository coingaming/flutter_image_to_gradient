import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum GradientStatus { initial, loading, extracted, error }

class GradientState extends Equatable {
  final GradientStatus status;
  final Uint8List imageBytes;
  final List<Color> extractedColors;
  final String? errorMessage;

  const GradientState({
    this.status = GradientStatus.initial,
    required this.imageBytes,
    this.extractedColors = const [],
    this.errorMessage,
  });

  GradientState copyWith({
    GradientStatus? status,
    Uint8List? imageBytes,
    List<Color>? extractedColors,
    String? errorMessage,
  }) {
    return GradientState(
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      extractedColors: extractedColors ?? this.extractedColors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory GradientState.initial() {
    return GradientState(
      status: GradientStatus.initial,
      imageBytes: Uint8List(0),
      extractedColors: const [],
    );
  }

  @override
  List<Object?> get props =>
      [status, imageBytes, extractedColors, errorMessage];
}
