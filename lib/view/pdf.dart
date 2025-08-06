// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:dio/dio.dart';

// class PDFPreviewWithFirstPage extends StatefulWidget {
//   const PDFPreviewWithFirstPage({super.key});

//   @override
//   State<PDFPreviewWithFirstPage> createState() =>
//       _PDFPreviewWithFirstPageState();
// }

// class _PDFPreviewWithFirstPageState extends State<PDFPreviewWithFirstPage> {
//   final List<Map<String, String>> pdfList = [
//     {
//       "title": "Pan card.pdf",
//       "url": "https://www.africau.edu/images/default/sample.pdf",
//     },
//     {
//       "title": "Adhar card.pdf",
//       "url":
//           "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
//     },
//   ];

//   Map<String, Image?> previewImages = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadPreviews();
//   }

//   Future<void> _loadPreviews() async {
//     for (var pdf in pdfList) {
//       final image = await _renderFirstPage(pdf["url"]!);
//       setState(() {
//         previewImages[pdf["url"]!] = image;
//       });
//     }
//   }

//   Future<Image?> _renderFirstPage(String url) async {
//     try {
//       // Download PDF to temp file
//       final dir = await getTemporaryDirectory();
//       final filePath = "${dir.path}/${url.split('/').last}";
//       final file = File(filePath);

//       if (!await file.exists()) {
//         final response = await Dio().download(url, filePath);
//         if (response.statusCode != 200) return null;
//       }

//       final doc = await PdfDocument.openFile(filePath);
//       PdfPage page = await doc.getPage(1);
//       final pageImage = await page.render(width: 300, height: 400);
//       // await page.dispose();

//       return Image.memory(pageImage.pixels);
//     } catch (e) {
//       print("Error rendering PDF: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff0d1418),
//       appBar: AppBar(title: const Text("PDF Previews")),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: pdfList.length,
//         itemBuilder: (context, index) {
//           final pdf = pdfList[index];
//           final preview = previewImages[pdf["url"]];

//           return Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xff055E55),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               width: MediaQuery.of(context).size.width * 0.75,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First Page Preview
//                   ClipRRect(
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(16)),
//                     child: preview ??
//                         Container(
//                           height: 100,
//                           color: Colors.white,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Icon(Icons.picture_as_pdf,
//                             color: Colors.white, size: 36),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 pdf["title"]!,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 "2 pages · 144 KB · pdf",
//                                 style: TextStyle(
//                                     color: Colors.white70, fontSize: 13),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(right: 12, bottom: 8),
//                     child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text(
//                         "6:10 PM",
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
