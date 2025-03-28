import '../implementations/image_processor_impl.dart';

abstract interface class ImageProcessorInterface {
  Future<ImageProcessorResult?> processorFromAsset(String assetPath);
  Future<ImageProcessorResult?> processorFromGallery();
  Future<ImageProcessorResult?> processorFromUrl(String imageUrl);
}
