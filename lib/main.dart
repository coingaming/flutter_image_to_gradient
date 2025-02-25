import 'package:flutter/material.dart';
import 'presentaion/screens/home_page.dart';

void main() {
  runApp(const ImageGradient());
}

class ImageGradient extends StatelessWidget {
  const ImageGradient({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: const HomePage(),
        ));
  }
}
