sealed class DominantColorEvent {}

class LoadDominantColor extends DominantColorEvent {
  final String imagePath;

  LoadDominantColor(this.imagePath);
}
