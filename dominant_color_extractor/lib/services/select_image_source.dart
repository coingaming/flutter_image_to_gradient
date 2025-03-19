import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:dominant_color_extractor/interfaces/color_extractor_interface.dart';
import 'package:flutter/material.dart';
import 'image_loader.dart';

class ImageSelector {
  static Future<Map<String, dynamic>> selectAndExtractColors({
    required String sourceType,
    String? imageUrl,
  }) async {
    Uint8List? imageBytes =
        await selectImageSource(sourceType: sourceType, imageUrl: imageUrl);

    if (imageBytes == null) {
      return {'error': 'No image selected'};
    }

    List<Color> colors = await _extractColors(imageBytes);

    return {
      'imageBytes': imageBytes,
      'colors': colors,
    };
  }

  static Future<List<Color>> _extractColors(Uint8List imageBytes) async {
    IColorExtractor extractor = getColorExtractor();
    return await extractor.extractColors(imageBytes: imageBytes);
  }

  static Future<Uint8List?> selectImageSource({
    required String sourceType,
    String? imageUrl,
  }) async {
    switch (sourceType) {
      case "Gallery":
        return await ImageLoader.pickImageFromGallery();

      case "Assets":
        return await ImageLoader.readImageFromAssets(
            "assets/images/image_gradient.jpg");

      case "URL":
        if (imageUrl != null && imageUrl.trim().isNotEmpty) {
          return await ImageLoader.downloadImageFromUrl(imageUrl.trim());
        }
        return null;

      default:
        return null;
    }
  }
}
