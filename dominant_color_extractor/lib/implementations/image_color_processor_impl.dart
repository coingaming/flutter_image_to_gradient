import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:k_means_cluster/k_means_cluster.dart';
import '../config/img_processor_config.dart';
import '../interfaces/image_color_processor_interface.dart';

class ImageColorProcessorImpl implements ImageColorProcessorInterface {
  final ImgProcessorConfig config;
  final _cache = <int, List<Color>>{};

  ImageColorProcessorImpl({
    this.config = const ImgProcessorConfig(),
  });

  @override
  Future<List<Color>> extractColors({required Uint8List imageBytes}) async {
    final key = imageBytes.hashCode;
    if (_cache.containsKey(key)) return _cache[key]!;

    final colors = _extractColorsInternal(imageBytes);
    _cache[key] = colors;
    return colors;
  }

  List<Color> _extractColorsInternal(Uint8List imageData) {
    final decoded = img.decodeImage(imageData);
    if (decoded == null) return [Colors.grey];

    final resized = _resizeImage(decoded, config.targetImageSize);
    final clustered = _clusterColors(resized, config.numberOfClusters);
    final filtered = _filterColorsByBrightness(clustered);

    filtered.sort(
        (a, b) => _calculateBrightness(a).compareTo(_calculateBrightness(b)));

    return filtered;
  }

  img.Image _resizeImage(img.Image image, int size) {
    return img.copyResize(image, width: size, height: size);
  }

  List<Color> _clusterColors(img.Image image, int clustersCount) {
    final instances = <Instance>[];

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final color = image.getPixel(x, y);
        instances.add(Instance(location: [
          img.getRed(color),
          img.getGreen(color),
          img.getBlue(color)
        ], id: '$x-$y'));
      }
    }

    if (instances.isEmpty) return [_averageColor(image)];

    final clusters = initialClusters(clustersCount, instances, seed: 0);
    kMeans(clusters: clusters, instances: instances);

    return clusters.map((c) => _clusterToColor(c)).toList();
  }

  Color _clusterToColor(Cluster cluster) {
    if (cluster.instances.isEmpty) return Colors.grey;
    final c = cluster.instances.first.location;
    return Color.fromRGBO(c[0].toInt(), c[1].toInt(), c[2].toInt(), 1);
  }

  Color _averageColor(img.Image image) {
    int r = 0, g = 0, b = 0, count = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final color = image.getPixel(x, y);
        r += img.getRed(color);
        g += img.getGreen(color);
        b += img.getBlue(color);
        count++;
      }
    }

    if (count == 0) return Colors.grey;

    return Color.fromRGBO(r ~/ count, g ~/ count, b ~/ count, 1);
  }

  List<Color> _filterColorsByBrightness(List<Color> colors) {
    return colors.where((c) {
      final brightness = _calculateBrightness(c);
      return brightness > 30 && brightness < 180;
    }).toList();
  }

  double _calculateBrightness(Color color) {
    return 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
  }
}
