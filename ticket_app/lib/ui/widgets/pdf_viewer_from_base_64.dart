import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerFromBase64 extends StatefulWidget {
  final String base64PDF;

  PDFViewerFromBase64({required this.base64PDF});

  @override
  _PDFViewerFromBase64State createState() => _PDFViewerFromBase64State();
}

class _PDFViewerFromBase64State extends State<PDFViewerFromBase64> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _createFileFromBase64(widget.base64PDF);
  }

  Future<void> _createFileFromBase64(String base64Str) async {
    final bytes = base64Decode(base64Str);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return localPath != null
        ? PDFView(
            filePath: localPath!,
            autoSpacing: false,
            pageFling: true,
            
          )
        : Center(child: CircularProgressIndicator());
  }
}
