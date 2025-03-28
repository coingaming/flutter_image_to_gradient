import 'dart:typed_data';
import 'dart:ui';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:dominant_color_extractor/implementations/image_sources_impl.dart';
import '../interfaces/image_processor_interface.dart';
import '../interfaces/image_source_interface.dart';

class ImageProcessorImpl implements ImageProcessorInterface {
  final ImageColorProcessorInterface _colorProcessor;
  final ImageSourceInterface _imageSourse;

  ImageProcessorImpl({
    ImageColorProcessorInterface? colorProcessor,
    ImageSourceInterface? imageSource,
  })  : _colorProcessor = colorProcessor ?? ImageColorProcessorImpl(),
        _imageSourse = imageSource ?? ImageSourceImpl();

  @override
  Future<ImageProcessorResult?> processorFromUrl(String imageUrl) async {
    final imageBytes = await _imageSourse.downloadImageFromUrl(imageUrl);

    final colors = await _colorProcessor.extractColors(imageBytes: imageBytes);
    if (colors.isEmpty) {
      return null;
    }
    return ImageProcessorResult(colors, imageBytes!);
  }

  @override
  Future<ImageProcessorResult?> processorFromGallery() async {
    final imageBytes = await _imageSourse.pickImageFromGallery();

    final colors = await _colorProcessor.extractColors(imageBytes: imageBytes);
    if (colors.isEmpty) {
      return null;
    }

    return ImageProcessorResult(colors, imageBytes!);
  }

  @override
  Future<ImageProcessorResult?> processorFromAsset(String assetPath) async {
    final imageBytes = await _imageSourse.readImageFromAssets(assetPath);
    final colors = await _colorProcessor.extractColors(imageBytes: imageBytes);
    if (colors.isEmpty) {
      return null;
    }

    return ImageProcessorResult(colors, imageBytes!);
  }
}

class ImageProcessorResult {
  final List<Color> colors;
  final Uint8List imageBytes;

  ImageProcessorResult(this.colors, this.imageBytes);
}
