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
  late Uint8List imageBytes;
  List<Color> extractedColors = [];

  Future<void> _extractColors(ImageSourceType sourceType) async {
    setState(() => isLoading = true);

    final result = switch (sourceType) {
      ImageSourceType.url =>
        await _processor.processorFromUrl(_imageUrlController.text.trim()),
      ImageSourceType.gallery => await _processor.processorFromGallery(),
      ImageSourceType.assets =>
        await _processor.processorFromAsset('assets/images/image_gradient.jpg'),
    };

    setState(() {
      isLoading = false;
      if (result == null) {
        extractedColors = [];
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
              UrlInputField(controller: _imageUrlController),
              const SizedBox(height: 20),
              ImageSourceButtons(onSelect: _extractColors),
              const SizedBox(height: 20),
              ExtractButton(
                onPressed: () => _extractColors(ImageSourceType.url),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator(color: Colors.blue)
              else ...[
                if (extractedColors.isNotEmpty)
                  ImagePreview(imageBytes: imageBytes),
                const SizedBox(height: 20),
                if (extractedColors.length >= 2)
                  GradientPreview(colors: extractedColors),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;

  const UrlInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
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
}

class ImageSourceButtons extends StatelessWidget {
  final void Function(ImageSourceType) onSelect;

  const ImageSourceButtons({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.image, color: Colors.white),
          onPressed: () => onSelect(ImageSourceType.gallery),
          tooltip: "Pick from Gallery",
        ),
        IconButton(
          icon: const Icon(Icons.photo_library, color: Colors.white),
          onPressed: () => onSelect(ImageSourceType.assets),
          tooltip: "Load from Assets",
        ),
      ],
    );
  }
}

class ExtractButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ExtractButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text(
        'Extract Colors',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final Uint8List imageBytes;

  const ImagePreview({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(imageBytes),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class GradientPreview extends StatelessWidget {
  final List<Color> colors;

  const GradientPreview({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [colors.first, colors.last],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
