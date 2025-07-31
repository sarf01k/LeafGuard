import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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

Widget buildImage(File image) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.file(
      image,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  );
}

Widget buildDetails(BuildContext context, Map<String, dynamic>? treatmentDetails) {
  if (treatmentDetails == null) {
    return Center(
      child: Text(
        'No treatment information available.',
        style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w400),
      ),
    );
  }

  if (treatmentDetails['name'] == 'Background') {
    return Center(
      child: Text(
        'No plant detected.',
        style: const TextStyle(fontSize: 16, color: Color(0xFFD32F2F), fontWeight: FontWeight.w400),
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.smart_toy_outlined, size: 16),
          const SizedBox(width: 6),
          const Text(
            'AI Diagnosis: ',
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          Text(
            treatmentDetails['name'],
            style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      const SizedBox(height: 20),
      treatmentDetails['name'].toString().contains('Healthy')
      ? Column(
        children: [
          Center(
            child: Text(
              'No treatment needed.',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 20),
          Text(
              treatmentDetails['application'],
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
            ),
        ],
      )
      : Text(
        treatmentDetails['overview'],
        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      const SizedBox(height: 20),
      const Text(
        "Symptoms",
        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      ...treatmentDetails['symptoms'].entries.map<Widget>((entry) {
        return Column(
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '• ${entry.key} - ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: entry.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5)
          ],
        );
      }).toList(),
      const SizedBox(height: 20),
      const Text(
        "Mode of Spread",
        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      ...treatmentDetails['spread'].entries.map<Widget>((entry) {
        return Column(
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '• ${entry.key} - ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: entry.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5)
          ],
        );
      }).toList(),
      const SizedBox(height: 20),
      const Text(
        "Chemical Control & Application",
        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            const TextSpan(
              text: 'Recommended Chemical: ',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: '${treatmentDetails['chemical']}\n',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: 'Organic Options: ',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: treatmentDetails['organic'],
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(
        treatmentDetails['application'],
        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
      ),
      const SizedBox(height: 20),
      const Text(
        "Management",
        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      ...treatmentDetails['management'].entries.map<Widget>((entry) {
        return Column(
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '• ${entry.key} - ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: entry.value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5)
          ],
        );
      }).toList(),
      const SizedBox(height: 20)
    ],
  );
}
