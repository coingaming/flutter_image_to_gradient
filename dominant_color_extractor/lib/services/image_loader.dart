import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageLoader {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<Uint8List?> loadImageBytes({
    String? imageUrl,
    String? localFilePath,
    String? assetPath,
    Uint8List? existingImageBytes,
  }) async {
    if (imageUrl != null) return await downloadImageFromUrl(imageUrl);
    if (assetPath != null) return await readImageFromAssets(assetPath);
    return existingImageBytes;
  }

  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      String platform = kIsWeb ? "Web" : "Mobile";

      switch (platform) {
        case "Web":
          debugPrint("Opening file picker for web...");
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );

          if (result == null) {
            debugPrint("No image selected.");
            return null;
          }

          Uint8List? bytes = result.files.first.bytes;
          if (bytes == null) {
            debugPrint("Error: Image bytes are empty!");
            return null;
          }

          debugPrint("Image selected, size: ${bytes.length} bytes");
          return bytes;

        case "Mobile":
          debugPrint("Opening gallery...");
          final XFile? selectedImage =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          if (selectedImage == null) {
            debugPrint("No image selected.");
            return null;
          }

          debugPrint("Image selected: ${selectedImage.path}");
          Uint8List imageBytes = await File(selectedImage.path).readAsBytes();
          debugPrint("Image size: ${imageBytes.length} bytes");

          return imageBytes;

        default:
          debugPrint("⚠ Unknown platform.");
          return null;
      }
    } catch (error) {
      debugPrint("⚠ Error selecting image: $error");
      return null;
    }
  }

  static Future<Uint8List?> downloadImageFromUrl(String imageUrl) async {
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

  static Future<Uint8List?> readImageFromAssets(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (error) {
      return null;
    }
  }
}
