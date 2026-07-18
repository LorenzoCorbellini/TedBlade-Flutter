import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tedblade_app/theme.dart';

class UpNextWidget extends StatelessWidget {
  final Future<http.Response> nextTalk;

  const UpNextWidget({super.key, required this.nextTalk});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nextTalk,
      builder: (context, snapshot) {
        // Still loading
        if (context.mounted &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Errored
        if (snapshot.hasError) {
          return const Text('Impossibile caricare il prossimo talk');
        }

        // Success, data is ready
        if (snapshot.hasData) {
          final response = snapshot.data!;
          final body = jsonDecode(response.body);
          final talk = body['data'];
          return Card(
            color: AppTheme.colors.secondary,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 'Up Next'
                  Text(
                    'Up Next',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        talk['thumbnail_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white24,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Title
                  Text(
                    talk['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text.semiBold.copyWith(fontSize: 18),
                  ),
                  // Views
                  Text(
                    '${formatViews(talk['statistics']['viewCount_ted'])} views',
                    style: AppTheme.text.light.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  //Speaker (with person icon)
                  Row(
                    children: [
                      // Person icon
                      const Icon(
                        Icons.person_outline,
                        color: Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        talk['speakers'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text.regular.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String formatViews(dynamic views) {
    int viewCount = int.parse(views.toString());
    final compactFormatter = NumberFormat.compact(locale: 'en');
    return compactFormatter.format(viewCount);
  }
}
