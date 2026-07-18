
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tedblade_app/widgets/external_thumbnail.widget.dart';

class TalkDetails extends StatefulWidget {

  final Map<String, dynamic> talkData;

  const TalkDetails({
    super.key,
    required this.talkData,
  });

  @override
  State<StatefulWidget> createState() => _TalkDetailsState();
}

class _TalkDetailsState extends State<TalkDetails> {

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = widget.talkData['thumbnail_url'] ?? '';
    final FocusNode focusNode = FocusNode();

    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Bind esc key to 'go back'
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      // Content
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExternalThumbnail(thumbnailUrl: thumbnailUrl),
            ],
          ),
        ),
      ),
    );
  }
}
