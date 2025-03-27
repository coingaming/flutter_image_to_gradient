import '../implementations/image_processor_impl.dart';

abstract interface class ImageProcessorInterface {
  Future<ImageProcessorResult?> processorFromAsset(String assetPath);
  Future<ImageProcessorResult?> processorFromGalery();
  Future<ImageProcessorResult?> processorFromUrl(String imageUrl);
}
