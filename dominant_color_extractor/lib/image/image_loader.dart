import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // XFile - this library

class ImageLoader {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<Uint8List?> loadImageBytes({
    String? imageUrl,
    String? localFilePath,
    String? assetPath,
    Uint8List? existingImageBytes,
  }) async {
    if (imageUrl != null) return await _downloadImageFromUrl(imageUrl);
    if (localFilePath != null) return await _readImageFromFile(localFilePath);
    if (assetPath != null) return await _readImageFromAssets(assetPath);
    return existingImageBytes;
  }

  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? selectedImageReference =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      return selectedImageReference != null
          ? await File(selectedImageReference.path).readAsBytes()
          : null;
    } catch (error) {
      return null;
    }
  }

  static Future<Uint8List?> captureImageFromCamera() async {
    try {
      final XFile? capturedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      return capturedFile != null
          ? await File(capturedFile.path).readAsBytes()
          : null;
    } catch (error) {
      return null;
    }
  }

  static Future<Uint8List?> _downloadImageFromUrl(String imageUrl) async {
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

  static Future<Uint8List?> _readImageFromFile(String filePath) async {
    try {
      return await File(filePath).readAsBytes();
    } catch (error) {
      return null;
    }
  }

  static Future<Uint8List?> _readImageFromAssets(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (error) {
      return null;
    }
  }
}
