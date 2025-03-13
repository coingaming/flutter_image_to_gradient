import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:k_means_cluster/k_means_cluster.dart';
import 'image_loader.dart';

class DominantColorExtractor {
  static Future<List<Color>> extractColors(
      {String? imageUrl,
      String? localFilePath,
      String? assetPath,
      Uint8List? existingImageBytes,
      int targetImageSize = 200,
      int numberOfClusters = 20}) async {
    Uint8List? imageData = await ImageLoader.loadImageBytes(
      imageUrl: imageUrl,
      localFilePath: localFilePath,
      assetPath: assetPath,
      existingImageBytes: existingImageBytes,
    );
    if (imageData == null) return [];

    return _processImageAndExtractColors(
        imageData, targetImageSize, numberOfClusters);
  }

  static List<Color> _processImageAndExtractColors(
      Uint8List imageData, int targetImageSize, int numberOfClusters) {
    final img.Image? decodedImage = img.decodeImage(imageData);
    if (decodedImage == null) return [];

    final img.Image resizedImage = img.copyResize(decodedImage,
        width: targetImageSize, height: targetImageSize);

    List<Color> colorPalette =
        _getClusteredColors(resizedImage, numberOfClusters);
    colorPalette = _filterOutExtremeColors(colorPalette);
    colorPalette.sort(
        (a, b) => _calculateBrightness(a).compareTo(_calculateBrightness(b)));

    return colorPalette;
  }

  static List<Color> _getClusteredColors(
      img.Image image, int numberOfClusters) {
    List<Instance> pixelInstances = [];

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixelColor = image.getPixel(x, y);
        pixelInstances.add(Instance(location: [
          img.getRed(pixelColor),
          img.getGreen(pixelColor),
          img.getBlue(pixelColor)
        ], id: '$x-$y'));
      }
    }

    if (pixelInstances.isEmpty) return [Colors.grey];

    List<Cluster> clusters =
        initialClusters(numberOfClusters, pixelInstances, seed: 0);
    kMeans(clusters: clusters, instances: pixelInstances);

    return clusters.map((cluster) {
      if (cluster.instances.isEmpty) return Colors.grey;
      var colorComponents = cluster.instances.first.location;
      return Color.fromRGBO(
        colorComponents[0].toInt(),
        colorComponents[1].toInt(),
        colorComponents[2].toInt(),
        1,
      );
    }).toList();
  }

  static List<Color> _filterOutExtremeColors(List<Color> colors) {
    return colors.where((color) {
      double brightness = _calculateBrightness(color);
      return brightness > 15 && brightness < 240;
    }).toList();
  }

  static double _calculateBrightness(Color color) {
    return (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue);
  }
}
