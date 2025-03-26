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

  DominantColorState copyWith({
    DominantColorStatus? status,
    DominantColorModel? colorModel,
    String? imagePath,
    String? errorMessage,
  }) {
    return DominantColorState(
      status: status ?? this.status,
      colorModel: colorModel ?? this.colorModel,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, colorModel, imagePath, errorMessage];
}
