import 'dart:typed_data';

import '../implementations/select_image_source_impl.dart';

abstract class ImageSelectorInterface {
  Future<Uint8List?> selectImageSource({
    required ImageSourceType sourceType,
    String? imageUrl,
  });
}
