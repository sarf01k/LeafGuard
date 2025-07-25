import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafguard/services/disease_detector.dart';
import 'package:leafguard/utils/image_utils.dart';
import 'package:leafguard/utils/pdf_utils.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({super.key, required this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? result;
  bool isLoading = true;
  Map<String, dynamic>? treatmentDetails;

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

    final String jsonString =
        await rootBundle.loadString('assets/disease_data.json');
    final Map<String, dynamic> diseaseData = json.decode(jsonString);

    final Map<String, dynamic>? details = diseaseData[prediction];

    if (mounted) {
      setState(() {
        result = prediction;
        treatmentDetails = details;
        isLoading = false;
      });
    }
  }


  Widget buildDetails() {
    if (treatmentDetails == null) {
      return const Text("No information available.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          treatmentDetails!['name'] ?? result ?? '',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRich("Treatment: ", treatmentDetails!['treatment']),
        _buildRich("Chemical Control: ", treatmentDetails!['chemical']),
        _buildRich("Application: ", treatmentDetails!['application']),
        _buildRich("Organic Options: ", treatmentDetails!['organic']),
      ],
    );
  }

  Widget _buildRich(String label, String? value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value?.isNotEmpty == true ? "$value\n" : 'N/A\n'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diagnosis Result")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          widget.image,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildDetails(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      floatingActionButton: isLoading
    ? null
    : FloatingActionButton.extended(
        onPressed: () {
          if (treatmentDetails != null) {
            PdfSaver.saveDiagnosisPdf(
              context: context,
              imageFile: widget.image,
              treatmentDetails: treatmentDetails!,
            );
          }
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Save as PDF"),
      ),
    );
  }
}
