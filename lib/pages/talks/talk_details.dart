import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/theme.dart';
import 'package:tedblade_app/widgets/talks/external_thumbnail.dart';
import 'package:tedblade_app/widgets/talks/talk_accordion.dart';
import 'package:tedblade_app/widgets/talks/up_next.dart';
import 'package:url_launcher/url_launcher.dart';

class TalkDetails extends StatefulWidget {
  final Map<String, dynamic> talkData;
  final http.Client client;

  const TalkDetails({super.key, required this.talkData, required this.client});

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
    final views = widget.talkData['statistics'];

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Bind esc key to 'go back'
        // FIXME: tasto esc non funzione se cambiamo pagina e torniamo su questa
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Thumbnail
                  ExternalThumbnail(
                    thumbnailUrl: widget.talkData['thumbnail_url'],
                    onTap: () async {
                      final Uri url = Uri.parse(widget.talkData['url']);
                      final bool launched = await canLaunchUrl(url);
                      if (!context.mounted) return;

                      if (launched) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Unable to open TED')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    widget.talkData['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text.semiBold.copyWith(fontSize: 20),
                  ),
                  // Views
                  Text(
                    '${formatViews(views['viewCount_ted'])} views',
                    style: AppTheme.text.light.copyWith(fontSize: 16),
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
                        widget.talkData['speakers'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text.regular.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Transcript + YT Stats
                  TalkAccordion(
                    transcript: FetchUtils.fetchTalkTranscript(
                      widget.client,
                      widget.talkData['slug'],
                    ),
                    statistics: widget.talkData['statistics'],
                  ),
                  const SizedBox(height: 12),
                  UpNextWidget(
                    nextTalk: FetchUtils.fetchTalkBySlug(
                      widget.client,
                      widget.talkData['watch_next'],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatViews(dynamic views) {
    int viewCount = int.parse(views.toString());
    final compactFormatter = NumberFormat.compact(locale: 'en');
    return compactFormatter.format(viewCount);
  }
}
