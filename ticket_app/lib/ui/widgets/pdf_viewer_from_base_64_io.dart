// lib/ui/widgets/pdf_viewer_from_base64_io.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerFromBase64 extends StatefulWidget {
  final String base64PDF;
  const PDFViewerFromBase64({super.key, required this.base64PDF});

  @override
  State<PDFViewerFromBase64> createState() => _PDFViewerFromBase64State();
}

class _PDFViewerFromBase64State extends State<PDFViewerFromBase64> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final bytes = base64Decode(widget.base64PDF);
    final dir = await Directory.systemTemp.createTemp();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);
    if (mounted) {
      setState(() => localPath = file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return PDFView(
      filePath: localPath!,
      autoSpacing: false,
      pageFling: true,
    );
  }
}