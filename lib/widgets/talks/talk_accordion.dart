import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tedblade_app/theme.dart';

class TalkAccordion extends StatelessWidget {
  final Future transcript;
  final Map<String, dynamic> statistics;

  const TalkAccordion({
    super.key,
    required this.transcript,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: AppTheme.colors.secondary,
          child: const ExpansionTile(
            title: Row(
              children: [
                Icon(Icons.format_align_left_outlined, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Transcript',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            children: <Widget>[ListTile(title: Text("aaaaa"))],
          ),
        ),
        Card(
          color: AppTheme.colors.secondary,
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Row(
              children: [
                Icon(Icons.video_collection_rounded, size: 18),
                const SizedBox(width: 4),
                Text(
                  'YouTube Stats',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            children: <Widget>[formatStats(statistics)],
          ),
        ),
      ],
    );
  }

  SizedBox formatStats(Map<String, dynamic> statistics) {
    var viewCount = statistics["viewCount_yt"];
    var viewStr = viewCount != null
        ? '• ${formatStatistic(viewCount)} views'
        : 'Couldn\'t get views';

    var commentCount = statistics["commentCount_yt"];
    var commentStr = commentCount != null
        ? '• ${formatStatistic(commentCount)} comments'
        : 'Couldn\'t get comments';

    var likeCount = statistics["likeCount_yt"];
    var likeStr = likeCount != null
        ? '• ${formatStatistic(likeCount)} likes'
        : 'Couldn\'t get likes';

    var favoriteCount = statistics["favoriteCount_yt"];
    var favoriteStr = favoriteCount != null
        ? '• ${formatStatistic(favoriteCount)} favorites'
        : 'Couldn\'t get favorites';

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewStr),
            Text(commentStr),
            Text(likeStr),
            Text(favoriteStr),
          ],
        ),
      ),
    );
  }

  String formatStatistic(String stat) {
    int viewCount = int.parse(stat.toString());
    final compactFormatter = NumberFormat.compact(locale: 'en');
    return compactFormatter.format(viewCount);
  }
}
