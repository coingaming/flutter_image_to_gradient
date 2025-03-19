library dominant_color_extractor;

export 'services/image_color_extractor.dart';
import 'package:dominant_color_extractor/implementations/dominant_color_extractor_impl.dart';
import 'interfaces/color_extractor_interface.dart';

IColorExtractor getColorExtractor() {
  return ImageColorExtractorImpl();
}
