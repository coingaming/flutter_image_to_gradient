import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:k_means_cluster/k_means_cluster.dart';
import '../config/dominant_color_extractor.dart';

class DominantColorExtractor implements DominantColorExtractorInterface {
  @override
  Future<List<Color>> extractColors(
      {required Uint8List imageBytes,
      DominantColorExtractorConfig config =
          const DominantColorExtractorConfig()}) async {
    return _processImageAndExtractColors(
      imageBytes,
      config.targetImageSize,
      config.numberOfClusters,
    );
  }

  List<Color> _processImageAndExtractColors(
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

  List<Color> _getClusteredColors(img.Image image, int numberOfClusters) {
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

    Color calculateAverageColor(img.Image image) {
      int totalRed = 0, totalGreen = 0, totalBlue = 0;
      int count = 0;

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

      if (count == 0) return Colors.grey;

      return Color.fromRGBO(
        (totalRed ~/ count),
        (totalGreen ~/ count),
        (totalBlue ~/ count),
        1,
      );
    }

    if (pixelInstances.isEmpty) return [calculateAverageColor(image)];

    List<Cluster> clusters =
        initialClusters(numberOfClusters, pixelInstances, seed: 0);
    kMeans(clusters: clusters, instances: pixelInstances);

    pixelInstances.clear();

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

  List<Color> _filterOutExtremeColors(List<Color> colors) {
    return colors.where((color) {
      double brightness = _calculateBrightness(color);
      return brightness > 30 && brightness < 180;
    }).toList();
  }

  double _calculateBrightness(Color color) {
    return (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue);
  }
}
