import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/widgets/common/ai_assistant.dart';
import 'package:tedblade_app/widgets/talks/talk_card.dart';
import 'package:http/http.dart' as http;

class TalksFeed extends StatefulWidget {
  final http.Client client;

  const TalksFeed({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _TalksFeedState();
  }
}

class _TalksFeedState extends State<TalksFeed> {

  List<dynamic> talksData = [];
  final controller = ScrollController();

  final int _limit = 10;
  int _page = 1; // Le pagine iniziano da 1
  bool _isLoading = false;
  bool _hasMore = true;

  void _scrollListener() {
    if (_isLoading || !_hasMore) return;

    if (controller.offset >= controller.position.maxScrollExtent - 100) {
      fetchNextTalksPage();
    }
  }

  void fetchNextTalksPage() {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    FetchUtils.fetchTalksPaginated(widget.client, _page, _limit)
      .then((response) {
        if (!mounted) return;
        final body = jsonDecode(response.body);
        final talks = body['data'];
        final apiHasMore = body['meta']['hasMore'];

        setState(() {
          _hasMore = apiHasMore;
          talksData.addAll(talks);
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
    fetchNextTalksPage();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        talksData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(10),
                  itemCount: talksData.length + 1,
                  itemBuilder: (context, index) {
                    if (index < talksData.length) {
                      final talk = talksData[index];
                      return TalkFeedCard(
                        title: talk['title'],
                        duration: talk['duration'],
                        views: talk['statistics'],
                        slug: talk['slug'],
                        thumbnailUrl: talk['thumbnail_url'],
                        speakers: talk['speakers'],
                        url: talk['url']
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
