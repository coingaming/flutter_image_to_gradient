import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:image_gra/models/dominant_color_model.dart';

enum DominantColorStatus { initial, loading, loaded, error }

class DominantColorState extends Equatable {
  final String? imagePath;
  final DominantColorStatus status;
  final DominantColorModel? colorModel;
  final String? errorMessage;

  const DominantColorState(
      {this.status = DominantColorStatus.initial,
      this.colorModel,
      this.imagePath,
      this.errorMessage});

  DominantColorState copyWith({DominantColorStatus? status, Color? color}) {
    return DominantColorState(
      status: status ?? this.status,
      imagePath: imagePath,
      colorModel: colorModel ?? colorModel,
      errorMessage: errorMessage ?? errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, colorModel, imagePath, errorMessage];
}
