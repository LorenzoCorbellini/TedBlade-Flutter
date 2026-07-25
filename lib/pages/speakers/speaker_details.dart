import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/theme.dart';
import 'package:tedblade_app/widgets/speakers/speaker_details_mini.dart';
import 'package:tedblade_app/widgets/talks/talk_card.dart';

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
  final List<dynamic> talks = [];
  final controller = ScrollController();
  bool _isLoading = false;
  bool _hasFetched = false;

  void _scrollListener() {
    if (_isLoading) return;
    if (controller.hasClients && controller.position.maxScrollExtent > 0) {
      if (controller.offset >= controller.position.maxScrollExtent - 100) {
        fetchTalks();
      }
    }
  }

  @override
  void initState() {
    controller.addListener(_scrollListener);
    fetchTalks();
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  dynamic fetchTalks() {
    if (_isLoading || _hasFetched) return;
    _hasFetched = true;
    setState(() => _isLoading = true);

    final slugs = widget.speakerData['talkSlugs'] as List? ?? [];

    for (final talk in slugs) {
      FetchUtils.fetchTalkBySlug(widget.client, talk['slug'])
          .then((response) {
            if (!mounted) return;
            final body = jsonDecode(response.body);
            final talkData = body['data'];
            setState(() {
              talks.add(talkData);
              _isLoading = false;
            });
          })
          .catchError((error) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Impossibile caricare il talk: $error'),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior
                    .floating,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SpeakerMini(speakerData: widget.speakerData),
                SizedBox(height: 20),
                Text('Talks', style: AppTheme.text.bold.copyWith(fontSize: 24)),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: talks.length,
                    itemBuilder: (context, index) {
                      if (index < talks.length) {
                        final talk = talks[index];
                        return TalkFeedCard(talkData: talk);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
