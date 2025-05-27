import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageWithFallback extends StatelessWidget {
  final String? base64String;
  final double height;
  final double width;
  final String defaultAssetPath;

  const Base64ImageWithFallback({
    Key? key,
    required this.base64String,
    required this.height,
    required this.width,
    this.defaultAssetPath = 'assets/default-featured-image.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (base64String != null) {
      try {
        imageBytes = base64Decode(base64String!);
      } catch (_) {
        imageBytes = null;
      }
    }

    return imageBytes != null
        ? Image.memory(
            imageBytes,
            height: height,
            width: width,
          )
        : Image.asset(
            defaultAssetPath,
            height: height,
            width: width,
          );
  }
}
