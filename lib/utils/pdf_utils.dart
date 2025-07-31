import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
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
          SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      final pdf = pw.Document();
      // final imageBytes = await imageFile.readAsBytes();
      // final pdfImage = pw.MemoryImage(imageBytes);

      final pdfImage = await buildPdfImage(imageFile);
      final pdfDetails = await buildPdfDetails(treatmentDetails);

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
              pdfImage,
              pw.SizedBox(height: 20),
              pdfDetails
            ],
          ),
      );

      final dir = Directory('/storage/emulated/0/Download/LeafGuard');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File("${dir.path}/${treatmentDetails['name']}_$timestamp.pdf");

      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved to ${file.path}")),
      );
    } catch (e) {
      debugPrint("PDF generation failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF")),
      );
    }
  }


  static Future<pw.Widget> buildPdfImage(File image) async {
    final imageBytes = await image.readAsBytes();
    final pdfImage = pw.MemoryImage(imageBytes);

    return pw.ClipRRect(
      horizontalRadius: 12,
      verticalRadius: 12,
      child: pw.Image(
        pdfImage,
        height: 250,
        width: PdfPageFormat.a4.availableWidth,
        fit: pw.BoxFit.cover,
      ),
    );
  }

  static Future<pw.Widget> buildPdfDetails(Map<String, dynamic>? treatmentDetails) async {
    if (treatmentDetails == null || treatmentDetails['name'] == 'Background') {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Text(
          treatmentDetails == null ? 'No treatment information available.' : 'No plant detected.',
          style: pw.TextStyle(
            fontSize: 16,
            color: PdfColor.fromInt(0xFFD32F2F),
            fontWeight: pw.FontWeight.normal,
          ),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'AI Diagnosis: ',
              style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
            ),
            pw.Text(
              treatmentDetails['name'],
              style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        treatmentDetails['name'].toString().contains('Healthy')
        ? pw.Column(
          children: [
            pw.Center(
              child: pw.Text(
                'No treatment needed.',
                style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
                treatmentDetails['application'],
                style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
              ),
          ],
        )
        : pw.Text(
          treatmentDetails['overview'],
          style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          "Symptoms",
          style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
        ),
        ...treatmentDetails['symptoms'].entries.map<pw.Widget>((entry) {
          return pw.Column(
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: '* ${entry.key} - ',
                      style: pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: entry.value,
                      style:  pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5)
            ],
          );
        }).toList(),
        pw.SizedBox(height: 20),
        pw.Text(
          "Mode of Spread",
          style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
        ),
        ...treatmentDetails['spread'].entries.map<pw.Widget>((entry) {
          return pw.Column(
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: '* ${entry.key} - ',
                      style:  pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: entry.value,
                      style:  pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5)
            ],
          );
        }).toList(),
        pw.SizedBox(height: 20),
        pw.Text(
          "Chemical Control & Application",
          style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
        ),
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: 'Recommended Chemical: ',
                style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
              ),
              pw.TextSpan(
                text: '${treatmentDetails['chemical']}\n',
                style:  pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
              ),
              pw.TextSpan(
                text: 'Organic Options: ',
                style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
              ),
              pw.TextSpan(
                text: treatmentDetails['organic'],
                style:  pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          treatmentDetails['application'],
          style:  pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.normal),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          "Management",
          style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0x000000), fontWeight: pw.FontWeight.bold),
        ),
        ...treatmentDetails['management'].entries.map<pw.Widget>((entry) {
          return pw.Column(
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: '* ${entry.key} - ',
                      style:  pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: entry.value,
                      style:  pw.TextStyle(
                        fontSize: 16,
                        color: PdfColor.fromInt(0x000000),
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5)
            ],
          );
        }).toList(),
        pw.SizedBox(height: 20)
      ],
    );
  }
}
