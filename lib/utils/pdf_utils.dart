import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PdfSaver {
  static Future<void> saveDiagnosisPdf({
    required BuildContext context,
    required File imageFile,
    required Map<String, dynamic> treatmentDetails,
  }) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      final pdf = pw.Document();
      final imageBytes = await imageFile.readAsBytes();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(pdfImage, height: 250)),
              pw.SizedBox(height: 20),
              if (treatmentDetails.isNotEmpty) ...[
                pw.Text(
                  treatmentDetails['name'] ?? '',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPdfRich("Treatment: ", treatmentDetails['treatment']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Chemical Control: ", treatmentDetails['chemical']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Application: ", treatmentDetails['application']),
                pw.SizedBox(height: 5),
                _buildPdfRich("Organic Options: ", treatmentDetails['organic']),
              ]
            ],
          ),
        ),
      );

      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File("${dir.path}/${treatmentDetails['name']}_$timestamp.pdf");

      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved to ${file.path}")),
      );
    } catch (e) {
      debugPrint("PDF generation failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save PDF")),
      );
    }
  }

  static pw.Widget _buildPdfRich(String label, String? value) {
    final lines = (value ?? 'N/A').split('\n');
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: lines.join('\n')),
        ],
      ),
    );
  }
}
