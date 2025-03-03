import 'package:flutter/material.dart';
import '../../dominant_color_extractor.dart';

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
  late ImageProvider imageProvider;
  List<Color> dominantColors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    imageProvider = const AssetImage('assets/images/image_gradient.jpg');
    extractColors();
  }

  Future<void> extractColors() async {
    setState(() {
      isLoading = true;
    });

    List<Color> colors = await DominantColorExtractor.extractDominantColors(
      imageProvider,
      maxColors: 100,
    );

    setState(() {
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
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
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
                          colors: [dominantColors.first, dominantColors.last],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
