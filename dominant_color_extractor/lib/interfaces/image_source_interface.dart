import 'dart:typed_data';

abstract interface class ImageSourceInterface {
  Future<Uint8List?> downloadImageFromUrl(String imageUrl);
  Future<Uint8List?> readImageFromAssets(String assetPath);
  Future<Uint8List?> pickImageFromGallery();
}
