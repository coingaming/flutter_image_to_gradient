import 'dart:typed_data';
import '../implementations/image_selector_impl.dart';

abstract class ImageSelectorInterface {
  Future<Uint8List?> selectImageSource({
    required ImageSourceType sourceType,
    String? imageUrl,
  });
}
