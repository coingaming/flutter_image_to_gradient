## Dominant Color Extractor


### What is Dominant Color Extractor?
Dominant Color Extractor is a Flutter library that library that extracts the most important colors from an image and creates a smooth gradient. You can use it to generate color palettes or create dynamic UI themes based on images.

## Example

https://github.com/coingaming/flutter_image_to_gradient/issues/5#issue-2918212287


## Install the library

- First you need to install the library from pub.dev.
- Add this to your 'pubspec.yaml
- You can do this by running:
```flutter pub add dominant_color_extractor```
- After installation is complete, udpate your imports:
```flutter pub get```
- Great! Now use can use my library. 😃
## Features of Dominant Color Exractor 

## How does it works? 🤔
 ### Loads and image from a URL, local file, or assets.
- Extracts dominant colors using kMeans clustering.
- Filters out extreme colors (too dark or too bright)
- Sorts colors by brightness to create a smooth gradient.
- Returns a list of dominant colors that can be used in UI

### Why use this?
- Automatically extracts colors from any image.
- Creates a gradient based on the image's color palette.
- Filters out unwanted colors to keep only the best shades.
- Customizable - you can choose how many colors to extract

## Usage

```dart
Uint8List? imageBytes = await ImageLoader.loadImage(
  imageUrl: "https://example.com/image.jpg"
);
List<Color> colors = await DominantColorExtractor.extractColors(
  existingImageBytes: imageBytes,
  numberOfClusters: 100, 
print(colors);


Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: LinearGradient(
      colors: extractedColors.isNotEmpty
          ? extractedColors
          : [Colors.grey, Colors.black], 
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
);
```



## Library Structure

```shell
 lib/
  |image/
  |  |── image_color_extractor.dart
  |  |── image_loader.dart
  |  
  | ── dominant_color_extractor.dart
 
```

