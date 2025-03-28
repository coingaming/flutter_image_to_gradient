import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dominant_color_extractor/interfaces/image_source_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceImpl implements ImageSourceInterface {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? selectedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedImage == null) return null;
      return await File(selectedImage.path).readAsBytes();
    } catch (error) {
      debugPrint("⚠ Error selecting image: $error");
      return null;
    }
  }

  @override
  Future<Uint8List?> downloadImageFromUrl(String imageUrl) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      return Uint8List.fromList(response.data!);
    } catch (error) {
      return null;
    }
  }

  @override
  Future<Uint8List?> readImageFromAssets(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (error) {
      return null;
    }
  }
}
