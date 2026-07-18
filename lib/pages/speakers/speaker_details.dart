
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tedblade_app/widgets/speakers/speaker_thumbnail.dart';

class SpeakerDetails extends StatefulWidget {

  final Map<String, dynamic> speakerData;

  const SpeakerDetails({
    super.key,
    required this.speakerData
  });

  @override
  State<StatefulWidget> createState() => _SpeakerDetailsState();
}

class _SpeakerDetailsState extends State<SpeakerDetails> {
  
  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = widget.speakerData['thumbnailUrl'] ?? '';
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
              SpeakerThumbnail(thumbnailUrl: thumbnailUrl)
            ],
          ),
        ),
      ),
    );
  }
}