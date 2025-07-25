// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_filex/open_filex.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PdfService {
//   Future<void> generateAndSavePdf(BuildContext context, String title, String content, {Uint8List? imageBytes}) async {
//     // Store the context's mounted state before the async operation
//     // For a State object, you would use `mounted` directly.
//     final bool contextIsMounted = context.mounted; // Capture the mounted state here

//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 20),
//                 if (imageBytes != null) ...[
//                   pw.Center(
//                     child: pw.Image(pw.MemoryImage(imageBytes), height: 250),
//                   ),
//                   pw.SizedBox(height: 20),
//                 ],
//                 pw.Text(content, style: const pw.TextStyle(fontSize: 12)),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     try {
//       // Request storage permission before accessing directories
//       var status = await Permission.storage.request();

//       if (contextIsMounted) { // Check if context is still mounted AFTER the await
//         if (status.isGranted) {
//           final output = await getTemporaryDirectory();
//           // Ensure the directory exists
//           if (!await output.exists()) {
//             await output.create(recursive: true);
//           }

//           final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s.-]'), '_').replaceAll(' ', '_');
//           final file = File("${output.path}/$sanitizedTitle.pdf");

//           await file.writeAsBytes(await pdf.save());

//           await OpenFilex.open(file.path);

//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('PDF saved to: ${file.path}')),
//             );
//           }
//         } else {
//           // Permission denied
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Storage permission denied. Cannot save PDF.')),
//             );
//             openAppSettings();
//           }
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving PDF: $e')),
//         );
//       }
//     }
//   }
// }