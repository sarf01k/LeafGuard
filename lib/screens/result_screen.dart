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

  Widget _buildInfoSection(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: value?.isNotEmpty == true ? value : 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetails() {
    if (treatmentDetails == null) {
      return const Center(child: Text('No treatment information available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy_outlined, size: 16),
            SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'AI Diagnosis: ',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: treatmentDetails!['name'] ?? result ?? '',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Treatment Description",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
        _buildInfoSection('Treatment', treatmentDetails!['treatment']),
        const SizedBox(height: 10),
        Text(
          "Chemical Control & Application",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Recommended Chemical: ',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: '${treatmentDetails!['chemical']}\n',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: 'Organic Options: ',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: treatmentDetails!['organic'],
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoSection('Application', treatmentDetails!['application']),
        // _buildInfoSection('Organic Options', treatmentDetails!['organic']),
      ],
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        widget.image,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF21d660),
        elevation: 1,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 8.0),
          child: Container(
            // width: 40,
            // height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: const Color(0xFF21d660), size: 18),
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_horiz_rounded, color: const Color(0xFF21d660), size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildImage(),
                      const SizedBox(height: 20),
                      buildDetails(),
                      const SizedBox(height: 60),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (treatmentDetails != null) {
                PdfSaver.saveDiagnosisPdf(
                  context: context,
                  imageFile: widget.image,
                  treatmentDetails: treatmentDetails!,
                );
              }
            },
            icon: Icon(Icons.picture_as_pdf_rounded, size: 25, color: Colors.white),
            label: Text(
              'Save as PDF',
              style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}