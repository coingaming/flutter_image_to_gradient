import 'dart:typed_data';

import 'package:dominant_color_extractor/implementations/image_processor_impl.dart';

import 'package:dominant_color_extractor/interfaces/image_processor_interface.dart';

import 'package:flutter/material.dart';

enum ImageSourceType { url, gallery, assets }

class ColorExtractorScreen extends StatefulWidget {
  const ColorExtractorScreen({super.key});

  @override
  State<ColorExtractorScreen> createState() => _ColorExtractorScreenState();
}

class _ColorExtractorScreenState extends State<ColorExtractorScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final ImageProcessorInterface _processor = ImageProcessorImpl();

  bool isLoading = false;
  Uint8List? imageBytes;
  List<Color> extractedColors = [];

  Future<void> _extractColors(ImageSourceType sourceType) async {
    setState(() => isLoading = true);

    final result = switch (sourceType) {
      ImageSourceType.url =>
        await _processor.processorFromUrl(_imageUrlController.text.trim()),
      ImageSourceType.gallery => await _processor.processorFromGalery(),
      ImageSourceType.assets =>
        await _processor.processorFromAsset('assets/images/image_gradient.jpg'),
    };

    setState(() {
      isLoading = false;
      if (result == null) {
        extractedColors = [];
        imageBytes = null;
      } else {
        extractedColors = result.colors;
        imageBytes = result.imageBytes;
      }
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
                    onPressed: () => _extractColors(ImageSourceType.gallery),
                    tooltip: "Pick from Gallery",
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    onPressed: () => _extractColors(ImageSourceType.assets),
                    tooltip: "Load from Assets",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _extractColors(ImageSourceType.url),
                child: const Text('Extract Colors',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : Column(
                      children: [
                        if (imageBytes != null)
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(imageBytes!),
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
