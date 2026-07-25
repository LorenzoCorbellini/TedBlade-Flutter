import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/widgets/speakers/speaker_details_mini.dart';

class SpeakerDetails extends StatefulWidget {
  final Map<String, dynamic> speakerData;
  final http.Client client;

  const SpeakerDetails({
    super.key,
    required this.speakerData,
    required this.client,
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
    print(widget.speakerData);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Bind esc key to 'go back'
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: SpeakerMini(speakerData: widget.speakerData),
              ),
              // SpeakerThumbnail(thumbnailUrl: thumbnailUrl)
            ],
          ),
        ),
      ),
    );
  }
}
