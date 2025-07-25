import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafguard/services/disease_detector.dart';
import 'package:leafguard/utils/image_utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _saveAsPdf() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      final pdf = pw.Document();
      final imageBytes = await widget.image.readAsBytes();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(pdfImage, height: 250)),
              pw.SizedBox(height: 20),
              if (treatmentDetails != null) ...[
                pw.Text(
                  treatmentDetails!['name'] ?? '',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPdfRich("Treatment: ", treatmentDetails!['treatment']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Chemical Control: ", treatmentDetails!['chemical']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Application: ", treatmentDetails!['application']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Organic Options: ", treatmentDetails!['organic']),
              ]
            ],
          ),
        ),
      );

      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      final file = File("${dir.path}/${treatmentDetails!['name']}_$timestamp.pdf");

      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF saved to ${file.path}")),
        );
      }
    } catch (e) {
      debugPrint("PDF generation failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save PDF")),
        );
      }
    }
  }

  pw.Widget _buildPdfRich(String label, String? value) {
    final lines = (value ?? 'N/A').split('\n');
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(
            text: lines.join('\n'),
          ),
        ],
      ),
    );
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
      appBar: AppBar(title: const Text("Diagnosis Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
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
              onPressed: _saveAsPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Save as PDF"),
            ),
    );
  }
}
