import 'package:dominant_color_extractor/implementations/image_processor_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dominant_color_extractor/interfaces/image_processor_interface.dart';
import 'gradient_event.dart';
import 'gradient_state.dart';

class GradientBloc extends Bloc<GradientEvent, GradientState> {
  final ImageProcessorInterface _processor;

  GradientBloc(this._processor) : super(GradientState.initial()) {
    on<ExtractFromUrl>(_onExtractFromUrl);
    on<ExtractFromAsset>(_onExtractFromAsset);
    on<ExtractFromGallery>(_onExtractFromGallery);
    on<GenerateGradient>(_onGenerateGradient);
  }

  Future<void> _onExtractFromUrl(
      ExtractFromUrl event, Emitter<GradientState> emit) async {
    emit(state.copyWith(status: GradientStatus.loading));

    final result = await _processor.processorFromUrl(event.url);
    _handleResult(result, emit);
  }

  Future<void> _onExtractFromAsset(
      ExtractFromAsset event, Emitter<GradientState> emit) async {
    emit(state.copyWith(status: GradientStatus.loading));

    final result = await _processor.processorFromAsset(event.assetPath);
    _handleResult(result, emit);
  }

  Future<void> _onExtractFromGallery(
      ExtractFromGallery event, Emitter<GradientState> emit) async {
    emit(state.copyWith(status: GradientStatus.loading));

    final result = await _processor.processorFromGallery();
    _handleResult(result, emit);
  }

  void _handleResult(
      ImageProcessorResult? result, Emitter<GradientState> emit) {
    if (result != null) {
      emit(state.copyWith(
        status: GradientStatus.extracted,
        imageBytes: result.imageBytes,
        extractedColors: result.colors,
      ));
    } else {
      emit(state.copyWith(
        status: GradientStatus.error,
        extractedColors: [],
        errorMessage: 'Failed to extarct colors',
      ));
    }
  }

  void _onGenerateGradient(
      GenerateGradient event, Emitter<GradientState> emit) {
    emit(state.copyWith(extractedColors: event.colors));
  }
}
