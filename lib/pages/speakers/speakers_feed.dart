import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/search_utils.dart';
import 'package:tedblade_app/widgets/common/ai_assistant.dart';
import 'package:tedblade_app/widgets/speakers/speaker_card.dart';
import 'package:http/http.dart' as http;

class SpeakersFeed extends StatefulWidget {
  final http.Client client;
  final String searchQuery;

  const SpeakersFeed({super.key, required this.client, required this.searchQuery});

  @override
  State<StatefulWidget> createState() {
    return _SpeakersFeedState();
  }
}

class _SpeakersFeedState extends State<SpeakersFeed> {
  List<dynamic> speakersData = [];
  final controller = ScrollController();

  final int _limit = 25;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<dynamic> get visibleSpeakersData {
    final query = widget.searchQuery.trim();
    if (query.isEmpty) {
      return speakersData;
    }

    return speakersData.where((speaker) => SearchUtils.matchesSpeaker(speaker as Map<String, dynamic>, query)).toList();
  }

  void _scrollListener() {
    if (_isLoading || !_hasMore || widget.searchQuery.isNotEmpty) return;

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
    final items = visibleSpeakersData;

    return Stack(
      children: [
        speakersData.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? Center(
                    child: Text(
                      widget.searchQuery.isEmpty
                          ? 'Nessun speaker disponibile'
                          : 'Nessuno speaker trovato',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : Center(
                    child: ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.all(10),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final speaker = items[index] as Map<String, dynamic>;
                        return SpeakerFeedCard(
                          name: speaker['speaker'],
                          talkSlugs: speaker['talks'] ?? [],
                          thumbnailUrl: speaker['thumbnail_url'],
                        );
                      },
                    ),
                  ),

        // Pulsante assistente AI
        AiAssistantBtn()
      ],
    );
  }
}
