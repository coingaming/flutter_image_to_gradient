import 'package:flutter/material.dart';

class ImageContainerWidget extends StatelessWidget {
  final String imagePath;
  const ImageContainerWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
