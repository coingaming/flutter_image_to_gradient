import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';

class ImageSelector {
  final ImageLoaderInterface _imageLoader;
  final ColorExtractorInterface _colorExtractorInterface;

  ImageSelector(this._imageLoader, this._colorExtractorInterface);

  Future<Uint8List?> selectImageSource(
      {required String sourceType, String? imageUrl}) async {
    switch (sourceType) {
      case "Gallery":
        return await _imageLoader.pickImageFromGallery();
      case "Assets":
        return await _imageLoader.loadImageBytes(
            assetPath: "assets/images/image_gradient.jpg");
      case "URL":
        return await _imageLoader.loadImageBytes(imageUrl: imageUrl);
    }
    return null;
  }

  Future<List<Color>> extractColors(Uint8List imageBytes) async {
    return await _colorExtractorInterface.extractColors(imageBytes: imageBytes);
  }
}
