import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gra/bloc/dominant_color_bloc.dart';
import 'package:image_gra/bloc/dominant_color_event.dart';
import 'package:image_gra/bloc/dominant_color_state.dart';
import 'package:image_gra/presentaion/widgets/image_container_widget.dart';

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
          DominantColorBloc()..add(LoadDominantColor(imagePath)),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Dominant Color Extractor',
            style: TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
          ),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<DominantColorBloc, DominantColorState>(
          builder: (context, state) {
            const errorWidget = Center(
              child: Text(
                "Error process loading",
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [darkestColor, lightestColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomCenter,
                              ),
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
