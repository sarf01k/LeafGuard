import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class DiseaseDetector {
  late Interpreter interpreter;
  late List<String> labels;

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/model.tflite');
    String labelData = await rootBundle.loadString('assets/plant_labels.txt');
    labels = labelData.split('\n');
  }

  Future<String> predict(Float32List imageInput) async {
    // Adjust input size as required by model (e.g. [1, 224, 224, 3])
    var input = imageInput.reshape([1, 224, 224, 3]);
    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    interpreter.run(input, output);

    final confidences = List<double>.from(output[0]);
    final maxValue = confidences.reduce((a, b) => a > b ? a : b);
    final predictedIndex = confidences.indexOf(maxValue);

    return labels[predictedIndex];
  }
}