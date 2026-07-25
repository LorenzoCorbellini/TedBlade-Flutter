import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tedblade_app/theme.dart';
import 'package:tedblade_app/widgets/speakers/speaker_thumbnail.dart';

class SpeakerMini extends StatelessWidget {
  final Map<String, dynamic> speakerData;

  const SpeakerMini({super.key, required this.speakerData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SpeakerThumbnail(thumbnailUrl: speakerData['thumbnail_url']),
        ),
        SizedBox(width: 12),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(speakerData['name'], style: AppTheme.text.bold.copyWith(fontSize: 18),),
            Text(getTotalStatFormatted(speakerData, 'viewCount_ted') + ' total views'),
            SizedBox(height: 20),
            Text('YouTube Stats:', style: AppTheme.text.semiBold.copyWith(fontSize: 14),),
            Text(getTotalStatFormatted(speakerData, 'viewCount_yt') + ' views'),
            Text(getTotalStatFormatted(speakerData, 'likeCount_yt') + ' likes'),
            Text(getTotalStatFormatted(speakerData, 'commentCount_yt') + ' comments'),
          ],
        ),
      ],
    );
  }

  String getTotalStatFormatted(Map<String, dynamic> speakerData, String stat) {
    return formatStatistic(getTotalStat(speakerData, stat));
  }

  String getTotalStat(Map<String, dynamic> speakerData, String stat) {
    int total = 0;
    final talks = speakerData['talkSlugs'];
    for (var talk in talks) {
      final statistics = talk['statistics'];
      total += int.parse(statistics[stat] ?? '0');
    }
    return '$total';
  }

  // Format a single statistic
  String formatStatistic(String stat) {
    int viewCount = int.parse(stat.toString());
    if (viewCount == 0) return '-';
    final compactFormatter = NumberFormat.compact(locale: 'en');
    return compactFormatter.format(viewCount);
  }
}
