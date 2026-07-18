import 'package:flutter/material.dart';

class ExternalThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final VoidCallback onTap;

  const ExternalThumbnail({
    super.key,
    required this.thumbnailUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = thumbnailUrl.trim().isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
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
            Container(
              width: double.infinity,
              height: 220,
              color: Colors.black.withOpacity(0.3),
            ),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_new, size: 48, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  "Watch on TED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
