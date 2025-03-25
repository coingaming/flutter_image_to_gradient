import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';

import 'image_sources_manager_impl.dart';

enum ImageSourceType { gallery, assets, url }

class ImageSelectorImpl implements ImageSelectorInterface {
  final ImageSourceManagerInterface _imageSourceManager =
      ImageSourceManagerImpl();

  @override
  Future<Uint8List?> selectImageSource(
      {required ImageSourceType sourceType, String? imageUrl}) async {
    return switch (sourceType) {
      ImageSourceType.gallery =>
        await _imageSourceManager.pickImageFromGallery(),
      ImageSourceType.assets => await _imageSourceManager
          .readImageFromAssets("assets/images/image_gradient.jpg"),
      ImageSourceType.url => imageUrl != null
          ? await _imageSourceManager.downloadImageFromUrl(imageUrl)
          : null,
    };
  }
}
