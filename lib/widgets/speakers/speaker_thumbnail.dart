
import 'package:flutter/material.dart';

class SpeakerThumbnail extends StatelessWidget {
  final String thumbnailUrl;

  const SpeakerThumbnail({
    super.key,
    required this.thumbnailUrl
  });

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = thumbnailUrl.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasValidUrl)
            Image.network(
              thumbnailUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white24,
                    size: 48,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            )
          else
            Container(
              width: double.infinity,
              height: 220,
              color: Colors.grey[800],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.white24,
                size: 48,
              ),
            ),
        ],
      ),
    );
  }
}