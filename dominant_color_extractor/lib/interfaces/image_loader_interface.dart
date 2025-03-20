import 'dart:typed_data';

abstract interface class ImageLoaderInterface {
  Future<Uint8List?> loadImageBytes({
    String? imageUrl,
    String? localFilePath,
    String? assetPath,
    Uint8List? existingImageBytes,
  });

  Future<Uint8List?> pickImageFromGallery();
}
