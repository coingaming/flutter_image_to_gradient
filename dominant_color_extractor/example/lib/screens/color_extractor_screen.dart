import 'dart:typed_data';
import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:dominant_color_extractor/implementations/image_selector_impl.dart';
import 'package:flutter/material.dart';

class ColorExtractorScreen extends StatefulWidget {
  const ColorExtractorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ColorExtractorScreenState createState() => _ColorExtractorScreenState();
}

class _ColorExtractorScreenState extends State<ColorExtractorScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final _imageSourceManager = ImageSelectorImpl();
  final ImageColorProcessorImpl _extractor = ImageColorProcessorImpl();

  List<Color> extractedColors = [];
  bool isExtractingColors = false;
  Uint8List? loadedImageBytes;

  Future<void> _handleImageSelection(ImageSourceType sourceType) async {
    setState(() {
      isExtractingColors = true;
    });

    Uint8List? imageBytes = await _imageSourceManager.selectImageSource(
      imageUrl: _imageUrlController.text.trim(),
      sourceType: sourceType,
    );

    if (imageBytes == null) {
      setState(() {
        isExtractingColors = false;
        extractedColors = [];
        loadedImageBytes = null;
      });
      return;
    }

    List<Color> colors = await _extractor.extractColors(imageBytes: imageBytes);

    setState(() {
      isExtractingColors = false;
      extractedColors = colors;
      loadedImageBytes = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Dominant Color Extractor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _imageUrlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter image URL',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.white),
                    onPressed: () =>
                        _handleImageSelection(ImageSourceType.gallery),
                    tooltip: "Pick from Gallery",
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    onPressed: () =>
                        _handleImageSelection(ImageSourceType.assets),
                    tooltip: "Load from Assets",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleImageSelection(ImageSourceType.url),
                child: const Text('Extract Colors',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              const SizedBox(height: 20),
              isExtractingColors
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : Column(
                      children: [
                        if (loadedImageBytes != null)
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(loadedImageBytes!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (extractedColors.length >= 2)
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  extractedColors.first,
                                  extractedColors.last
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
