import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Converts a Uint8List image (e.g. from camera/gallery) into a Float32List for TFLite
Future<Float32List> processImage(Uint8List rawBytes) async {
  final image = img.decodeImage(rawBytes);
  if (image == null) {
    throw Exception('Could not decode image');
  }

  final resized = img.copyResize(image, width: 224, height: 224);

  final Float32List imageAsFloat32 = Float32List(224 * 224 * 3);
  int index = 0;

  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixel(x, y);

      imageAsFloat32[index++] = pixel.r / 255.0;
      imageAsFloat32[index++] = pixel.g / 255.0;
      imageAsFloat32[index++] = pixel.b / 255.0;
    }
  }

  return imageAsFloat32;
}