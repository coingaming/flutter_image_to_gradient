import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gra/bloc/dominant_color_bloc.dart';
import 'package:image_gra/bloc/dominant_color_event.dart';
import 'package:image_gra/bloc/dominant_color_state.dart';
import '../widgets/image_container_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String imagePath = "assets/images/image_gradient.jpg";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DominantColorBloc()..add(LoadDominantColor(imagePath: imagePath)),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Dominant Color Extractor',
            style: TextStyle(color: Color.fromARGB(255, 217, 217, 217)),
          ),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<DominantColorBloc, DominantColorState>(
          builder: (context, state) {
            const errorWidget = Center(
              child: Text(
                "Error loading colors",
                style: TextStyle(color: Colors.red),
              ),
            );

            switch (state.status) {
              case DominantColorStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );

              case DominantColorStatus.loaded:
                if (state.colorModel != null &&
                    state.colorModel!.colors.isNotEmpty) {
                  List<Color> gradientColors =
                      state.colorModel!.colors.take(100).toList();

                  gradientColors.sort((a, b) =>
                      a.computeLuminance().compareTo(b.computeLuminance()));

                  Color darkestColor = gradientColors.first;
                  Color lightestColor = gradientColors.last;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ImageContainerWidget(imagePath: imagePath),
                        const SizedBox(height: 20),
                        Container(
                          width: 500,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [darkestColor, lightestColor],
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return errorWidget;

              case DominantColorStatus.error:
              default:
                return errorWidget;
            }
          },
        ),
      ),
    );
  }
}
