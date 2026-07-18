import 'package:flutter/material.dart';
import 'package:tedblade_app/theme.dart';

class TalkAccordion extends StatelessWidget {
  const TalkAccordion({super.key});

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
            children: <Widget>[ListTile(title: Text('This is tile number 1'))],
          ),
        ),
        Card(
          color: AppTheme.colors.secondary,
          child: ExpansionTile(
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
            children: const <Widget>[
              ListTile(title: Text('This is tile number 2')),
            ],
          ),
        ),
      ],
    );
  }
}
