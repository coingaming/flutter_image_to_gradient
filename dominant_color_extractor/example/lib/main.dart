import 'dart:typed_data';

import 'package:dominant_color_extractor/dominant_color_extractor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ColorExtractorScreen(),
    );
  }
}

class ColorExtractorScreen extends StatefulWidget {
  const ColorExtractorScreen({super.key});

  @override
  _ColorExtractorScreenState createState() => _ColorExtractorScreenState();
}

class _ColorExtractorScreenState extends State<ColorExtractorScreen> {
  final TextEditingController _urlController = TextEditingController();
  List<Color> dominantColors = [];
  bool isLoading = false;
  Uint8List? imageBytes;

  Future<void> extractColors() async {
    setState(() {
      isLoading = true;
    });

    String imageUrl = _urlController.text.trim();
    if (imageUrl.isEmpty) return;

    Uint8List? bytes =
        await DominantColorExtractor.loadImageBytes(imageUrl: imageUrl);
    if (bytes == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<Color> colors =
        await DominantColorExtractor.extractDominantColors(imageBytes: bytes);

    setState(() {
      imageBytes = bytes;
      dominantColors = colors;
      isLoading = false;
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
          'Test: Dominant Color Extractor',
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
                  controller: _urlController,
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: extractColors,
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
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(imageBytes!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (dominantColors.length >= 2)
                          Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  dominantColors.first,
                                  dominantColors.last
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
