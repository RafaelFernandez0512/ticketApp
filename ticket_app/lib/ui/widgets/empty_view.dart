import 'package:flutter/material.dart';
import 'package:ticket_app/utils/gaps.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath; // Ruta de la imagen (local o red)
  final double imageHeight;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool isAssetImage;

  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
    this.imageHeight = 150,
    this.onRetry,
    this.retryText,
    this.isAssetImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = isAssetImage
        ? Image.asset(imagePath, height: imageHeight)
        : Image.network(imagePath, height: imageHeight);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget,
            gapH24,
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            gapH8,
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            gapH8,
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
