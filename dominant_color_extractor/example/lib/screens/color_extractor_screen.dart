import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dominant_color_extractor/interfaces/image_processor_interface.dart';
import 'package:dominant_color_extractor/implementations/image_processor_impl.dart';

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
        await _processor.processorFromAsset('assets/sample.jpg'),
    };

    setState(() {
      isLoading = false;
      if (result != null) {
        extractedColors = result.colors;
        imageBytes = result.imageBytes;
      } else {
        extractedColors = [];
        imageBytes = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dominant Color Extractor'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUrlInput(),
              const SizedBox(height: 20),
              _buildSourceButtons(),
              const SizedBox(height: 20),
              _buildExtractButton(),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator(color: Colors.blue)
              else
                _buildResults()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrlInput() {
    return SizedBox(
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
    );
  }

  Widget _buildSourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.image, color: Colors.white),
          tooltip: "Pick from Gallery",
          onPressed: () => _extractColors(ImageSourceType.gallery),
        ),
        IconButton(
          icon: const Icon(Icons.photo_library, color: Colors.white),
          tooltip: "Load from Assets",
          onPressed: () => _extractColors(ImageSourceType.assets),
        ),
      ],
    );
  }

  Widget _buildExtractButton() {
    return ElevatedButton(
      onPressed: () => _extractColors(ImageSourceType.url),
      child: const Text(
        'Extract Colors',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        if (imageBytes != null)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: MemoryImage(imageBytes!),
                fit: BoxFit.cover,
              ),
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
                colors: [extractedColors.first, extractedColors.last],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
      ],
    );
  }
}
