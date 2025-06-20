import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leafguard/services/disease_detector.dart';
import 'package:leafguard/utils/image_utils.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({super.key, required this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _runModel();
  }

  Future<void> _runModel() async {
    final detector = DiseaseDetector();
    await detector.loadModel();

    final inputTensor = await processImage(await widget.image.readAsBytes());
    final prediction = await detector.predict(inputTensor);

    if (mounted) {
      setState(() {
        result = prediction;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prediction Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Image.file(widget.image, height: 200),
                  const SizedBox(height: 20),
                  Text(
                    "Prediction: $result",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}