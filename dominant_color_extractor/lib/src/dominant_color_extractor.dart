import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class DominantColorExtractor {
  static Future<List<Color>> extractDominantColors(ImageProvider imageProvider,
      {int maxColors = 100}) async {
    final img.Image? image = await _convertImageProviderToImage(imageProvider);

    if (image == null) {
      return [];
    }

    final resizedImage = img.copyResize(image, width: 200, height: 200);

    Map<int, int> colorFrequency = {};

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        int alpha = img.getAlpha(pixel);

        if (alpha < 128) continue;

        colorFrequency[pixel] = (colorFrequency[pixel] ?? 0) + 1;
      }
    }

    List<int> sortedColors = colorFrequency.keys.toList()
      ..sort(
          (a, b) => (colorFrequency[b] ?? 0).compareTo(colorFrequency[a] ?? 0));

    List<Color> dominantColors = sortedColors.take(maxColors).map((pixel) {
      return Color.fromRGBO(
        img.getRed(pixel),
        img.getGreen(pixel),
        img.getBlue(pixel),
        1, // Fully opaque
      );
    }).toList();

    return dominantColors;
  }

  static Future<img.Image?> _convertImageProviderToImage(
      ImageProvider imageProvider) async {
    final Completer<img.Image?> completer = Completer();
    final ImageStream stream =
        imageProvider.resolve(const ImageConfiguration());

    stream.addListener(ImageStreamListener((ImageInfo info, bool _) async {
      try {
        final ByteData? byteData =
            await info.image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) {
          print("Error: Image byte data is null.");
          completer.complete(null);
          return;
        }

        final Uint8List uint8list = byteData.buffer.asUint8List();
        final img.Image? decodedImage = img.decodeImage(uint8list);

        if (decodedImage == null) {
          print("Error: Image could not be decoded.");
        }

        completer.complete(decodedImage);
      } catch (e) {
        print("Exception in _convertImageProviderToImage: $e");
        completer.complete(null);
      }
    }));

    return completer.future;
  }
}
