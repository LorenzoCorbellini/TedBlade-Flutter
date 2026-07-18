
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tedblade_app/widgets/talks/external_thumbnail.dart';

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
    final thumbnailUrl = widget.talkData['thumbnailUrl'] ?? '';

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
              ExternalThumbnail(thumbnailUrl: thumbnailUrl),
            ],
          ),
        ),
      ),
    );
  }
}
