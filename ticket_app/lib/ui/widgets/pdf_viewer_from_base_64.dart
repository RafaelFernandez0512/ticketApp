import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:html' as html; // Solo se usa en web

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
    _handlePDF(widget.base64PDF);
  }

  Future<void> _handlePDF(String base64Str) async {
    final bytes = base64Decode(base64Str);

    if (kIsWeb) {
      // Web: crear Blob y abrirlo en una nueva pestaña
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      // No mostramos nada en la pantalla actual
    } else {
      // Móvil / Desktop
      final dir = await io.Directory.systemTemp.createTemp();
      final file = io.File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);
      setState(() {
        localPath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(child: Text('El PDF fue abierto en otra pestaña.'));
    }

    return localPath != null
        ? PDFView(
            filePath: localPath!,
            autoSpacing: false,
            pageFling: true,
          )
        : const Center(child: CircularProgressIndicator());
  }
}
