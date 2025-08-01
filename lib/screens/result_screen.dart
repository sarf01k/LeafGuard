import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafguard/services/disease_detector.dart';
import 'package:leafguard/utils/image_utils.dart';
import 'package:leafguard/utils/pdf_utils.dart';
import 'package:shimmer/shimmer.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({super.key, required this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? result;
  bool isLoading = true;
  bool isSaved = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        elevation: 1,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 16),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2E2E2E),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF388E3C), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Result',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Color(0xFFE0E0E0),
                    highlightColor: Color(0xFFF5F5F5),
                    period: Durations.medium3,
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Shimmer.fromColors(
                    baseColor: Color(0xFFE0E0E0),
                    highlightColor: Color(0xFFF5F5F5),
                    period: Durations.medium3,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  buildImage(widget.image),
                  const SizedBox(height: 20),
                  buildDetails(context, treatmentDetails),
                  const SizedBox(height: 60),
                ],
              ),
      ),
      floatingActionButton: !isLoading ? SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: const Color(0xFF388E3C),
              backgroundColor: Color(0xFFD32F2F),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isSaved
              ? null
              : () async {
                await PdfSaver.saveDiagnosisPdf(
                  context: context,
                  imageFile: widget.image,
                  treatmentDetails: treatmentDetails!,
                );
                setState(() {
                  isSaved = true;
                });
              },
            icon: Icon(Icons.picture_as_pdf_rounded, size: 25, color: Colors.white),
            label: Text(
              isSaved ? 'Saved!' : 'Save as PDF',
              style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}