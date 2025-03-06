import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class DominantColorExtractor {
  static Future<List<Color>> extractDominantColors({
    String? imageUrl,
    String? filePath,
    String? assetPath,
    Uint8List? imageBytes,
    int maxColors = 100,
    int resizedHeight = 200,
    int resizedWidth = 200,
    totalRed = 0,
    totalGreen = 0,
    totalBlue = 0,
  }) async {
    Uint8List? bytes = await loadImageBytes(
      imageUrl: imageUrl,
      filePath: filePath,
      assetPath: assetPath,
      imageBytes: imageBytes,
    );
    if (bytes == null) return [];

    final img.Image? image = img.decodeImage(bytes);
    if (image == null) return [];

    final img.Image resizedImage = img.copyResize(
      image,
      width: resizedWidth,
      height: resizedHeight,
    );

    return _getDominantColors(resizedImage, maxColors);
  }

  static Future<Uint8List?> loadImageBytes({
    String? imageUrl,
    String? filePath,
    String? assetPath,
    Uint8List? imageBytes,
  }) async {
    if (imageUrl != null) return await _fetchImageBytes(imageUrl);
    if (filePath != null) return await _loadFileBytes(filePath);
    if (assetPath != null) return await _loadAssetsBytes(assetPath);
    return imageBytes;
  }

  static List<Color> _getDominantColors(img.Image image, int maxColors) {
    final resizedImage = img.copyResize(image, width: 200, height: 200);

    Map<int, int> colorFrequency = {};
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        int alpha = img.getAlpha(pixel);
        int red = img.getRed(pixel);
        int blue = img.getBlue(pixel);
        int green = img.getGreen(pixel);
        if (alpha < 128 ||
            (red > 240 && green > 240 && blue > 240) ||
            (red < 15 && green < 15 && blue < 15)) {
          continue;
        }

        colorFrequency[pixel] = (colorFrequency[pixel] ?? 0) + 1;
      }
    }

    List<int> sortedColors = colorFrequency.keys.toList()
      ..sort(
          (a, b) => (colorFrequency[b] ?? 0).compareTo(colorFrequency[a] ?? 0));

    return sortedColors.take(maxColors).map((pixel) {
      return Color.fromRGBO(
        img.getRed(pixel),
        img.getGreen(pixel),
        img.getBlue(pixel),
        1,
      );
    }).toList();
  }

  static Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (_) {
      return null;
    }
  }

  static Future<Uint8List?> _loadFileBytes(String filePath) async {
    try {
      return await File(filePath).readAsBytes();
    } catch (_) {
      return null;
    }
  }

  static Future<Uint8List?> _loadAssetsBytes(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }
}
