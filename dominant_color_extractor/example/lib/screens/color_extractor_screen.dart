import 'dart:typed_data';
import 'package:example/bloc/gradient_bloc.dart';
import 'package:example/bloc/gradient_event.dart';
import 'package:example/bloc/gradient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dominant_color_extractor/implementations/image_processor_impl.dart';

class ColorExtractorScreen extends StatefulWidget {
  const ColorExtractorScreen({super.key});

  @override
  State<ColorExtractorScreen> createState() => _ColorExtractorScreenState();
}

class _ColorExtractorScreenState extends State<ColorExtractorScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
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
      body: BlocProvider(
        create: (_) => GradientBloc(ImageProcessorImpl()),
        child: BlocBuilder<GradientBloc, GradientState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UrlInputField(controller: _imageUrlController),
                    const SizedBox(height: 20),
                    ImageSourceButtons(
                      onSelectGallery: () {
                        context.read<GradientBloc>().add(ExtractFromGallery());
                      },
                      onSelectAsset: () {
                        context.read<GradientBloc>().add(ExtractFromAsset(
                            'assets/images/image_gradient.jpg'));
                      },
                      onSelectUrl: () {
                        context
                            .read<GradientBloc>()
                            .add(ExtractFromUrl(_imageUrlController.text));
                      },
                    ),
                    const SizedBox(height: 20),
                    ExtractButton(
                      onPressed: () {
                        context
                            .read<GradientBloc>()
                            .add(ExtractFromUrl(_imageUrlController.text));
                      },
                    ),
                    const SizedBox(height: 20),
                    if (state.status == GradientStatus.loading)
                      const CircularProgressIndicator(color: Colors.blue)
                    else ...[
                      if (state.extractedColors.isNotEmpty)
                        ImagePreview(imageBytes: state.imageBytes),
                      const SizedBox(height: 20),
                      if (state.extractedColors.isNotEmpty)
                        GradientPreview(colors: state.extractedColors),
                    ],
                    if (state.status == GradientStatus.error)
                      Text('Error: ${state.errorMessage}',
                          style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageSourceButtons extends StatelessWidget {
  final void Function() onSelectGallery;
  final void Function() onSelectAsset;
  final void Function() onSelectUrl;

  const ImageSourceButtons({
    super.key,
    required this.onSelectGallery,
    required this.onSelectAsset,
    required this.onSelectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.image_search, color: Colors.white),
          onPressed: onSelectGallery,
          tooltip: "Pick from Gallery",
        ),
        IconButton(
          icon: const Icon(Icons.photo_library, color: Colors.white),
          onPressed: onSelectAsset,
          tooltip: "Load from Assets",
        ),
      ],
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
