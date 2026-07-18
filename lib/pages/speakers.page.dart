import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/widgets/ai_assistant.widget.dart';
import 'package:tedblade_app/widgets/speaker_card.widget.dart';
import 'package:http/http.dart' as http;

class SpeakersPage extends StatefulWidget {
  final http.Client client;

  const SpeakersPage({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _SpeakersPageState();
  }
}

class _SpeakersPageState extends State<SpeakersPage> {
  List<dynamic> speakersData = [];
  final controller = ScrollController();

  final int _limit = 10;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  void _scrollListener() {
    if (_isLoading || !_hasMore) return;

    if (controller.offset >= controller.position.maxScrollExtent - 100) {
      fetchNextSpeakersPage();
    }
  }

  void fetchNextSpeakersPage() {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    FetchUtils.fetchSpeakersPaginated(widget.client, _page, _limit)
      .then((response) {
        if (!mounted) return;
        final body = jsonDecode(response.body);
        final speakers = body['data'];
        final apiHasMore = body['meta']['hasMore'];

        setState(() {
          speakersData.addAll(speakers);
          _hasMore = apiHasMore;
          _page++;
          _isLoading = false;
        });
      })
      .catchError((error) {
        _isLoading = false;
        // TODO: display error
        print("Fetch error: $error");
      });
  }

  @override
  void initState() {
    controller.addListener(_scrollListener);
    fetchNextSpeakersPage();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        speakersData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(10),
                  itemCount: speakersData.length + 1,
                  itemBuilder: (context, index) {
                    if (index < speakersData.length) {
                      final speaker = speakersData[index];
                      return SpeakerFeedCard(
                        name: speaker['speaker'],
                        talkSlugs: speaker['talks'],
                        thumbnailUrl: speaker['thumbnail_url'],
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),

        // Pulsante assistente AI
        AiAssistantBtn()
      ],
    );
  }
}
