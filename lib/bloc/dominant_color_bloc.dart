import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_gra/bloc/dominant_color_event.dart';
import 'package:image_gra/bloc/dominant_color_state.dart';
import 'package:image_gra/models/dominant_color_model.dart';

class DominantColorBloc extends Bloc<DominantColorEvent, DominantColorState> {
  DominantColorBloc()
      : super(
            DominantColorState(imagePath: "assets/images/image_gradient.jpg")) {
    on<LoadDominantColor>(_mapLoadDominantColorToState);
  }
}

Future<void> _mapLoadDominantColorToState(
    LoadDominantColor event, Emitter<DominantColorState> emit) async {
  emit(DominantColorState(status: DominantColorStatus.loading));

  try {
    final DominantColorModel colorModel =
        await _getDominantColor(event.imagePath);
    emit(DominantColorState(
        status: DominantColorStatus.loaded, colorModel: colorModel));
  } catch (e, st) {
    debugPrint("Error in DominantColorBloc: $e");
    debugPrint("Stack trace $st");
    emit(DominantColorState(status: DominantColorStatus.error));
  }
}

Future<DominantColorModel> _getDominantColor(String imagePath) async {
  try {
    final ByteData data = await rootBundle.load(imagePath);
    final Uint8List bytes = data.buffer.asUint8List();
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) return DominantColorModel(colors: [Colors.grey]);

    Map<int, int> colorFrequency = {};

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        colorFrequency[pixel] = (colorFrequency[pixel] ?? 0) + 1;
      }
    }

    List<int> sortedColors = colorFrequency.keys.toList()
      ..sort(
          (a, b) => (colorFrequency[b] ?? 0).compareTo(colorFrequency[a] ?? 0));

    List<Color> dominantColors = sortedColors.take(100).map((pixel) {
      return Color.fromRGBO(
        img.getRed(pixel),
        img.getGreen(pixel),
        img.getBlue(pixel),
        1,
      );
    }).toList();

    return DominantColorModel(colors: dominantColors);
  } catch (e, st) {
    debugPrint("Error: during image loading $e");
    debugPrint("Stack trace: $st");
    return DominantColorModel(colors: [Colors.grey]);
  }
}
