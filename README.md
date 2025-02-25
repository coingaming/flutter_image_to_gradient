# Image Gradient Extractor 

**Image Gradient Extractor** is a Flutter application that analyzes an image and extracts its dominant colors to create a gradient background.

## Features 

- Load an image from `assets/images`
- Extract dominant colors using the `image` package
- Display a gradient based on the lighest and darkest shades
- Manage state using `Flutter BLoC`
- Optimize image size using compression

## Screenshot

![Image Gradient Extractor] (assest/images/image_gradient.jpg)

## Tech Stack

- **Flutter**: UI framework for cross-platform development
- **Dart**: Programming language
- **BLoC**: State management pattern
- **Image Processing**: `image` and `flutter_image_compress`

## Dependencies

Package                  | Description
-------------------------|-----------------------------
`flutter_bloc`           | State management using BLoC
`equatable`              | Simplifies object comparison
`image`                  | Image processing in Dart
`flutter_image_compress` | Compresses images to reduce file size
 
 ## Project Structure

```shell
 lib/
  |──bloc/
  |  |── dominant_color_bloc.dart
  |  |── dominant_color_event.dart
  |  |── dominant_color_state.dart
  | 
  |── models/
  |  |── dominant_color_model.dart
  |
  |── presentation/
  |  |── screens/
  |  |   |── home_page.dart
  |  |── widgets/
  |  |   |── image_container_widget.dart
  |
  |── main.dart
