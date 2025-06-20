import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:leafguard/services/disease_detector.dart';
import 'package:leafguard/utils/image_utils.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final detector = DiseaseDetector();
  String _predictionResult = 'No prediction yet';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await detector.loadModel();
  }

  Future<void> _runDetection() async {
    final byteData = await rootBundle.load('assets/images/grape esca.jpg');
final imageBytes = byteData.buffer.asUint8List();
    final inputTensor = await processImage(imageBytes);
    final result = await detector.predict(inputTensor);

    setState(() {
      _predictionResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_predictionResult),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runDetection,
              child: const Text('Start Detection'),
            ),
          ],
        ),
      ),
    );
  }
}