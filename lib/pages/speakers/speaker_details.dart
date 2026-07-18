
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
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = widget.speakerData['thumbnailUrl'] ?? '';

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Bind esc key to 'go back'
        // FIXME: tasto esc non funzione se cambiamo pagina e torniamo su questa
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