import 'package:equatable/equatable.dart';

sealed class DominantColorEvent extends Equatable {
  const DominantColorEvent();

  @override
  List<Object> get props => [];
}

class LoadDominantColor extends DominantColorEvent {
  final String imagePath;

  const LoadDominantColor({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}
