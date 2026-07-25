import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/search_utils.dart';
import 'package:tedblade_app/widgets/common/ai_assistant.dart';
import 'package:tedblade_app/widgets/talks/talk_card.dart';
import 'package:http/http.dart' as http;

class TalksFeed extends StatefulWidget {
  final http.Client client;
  final String searchQuery;

  const TalksFeed({super.key, required this.client, required this.searchQuery});

  @override
  State<StatefulWidget> createState() {
    return _TalksFeedState();
  }
}

class _TalksFeedState extends State<TalksFeed> {
  List<dynamic> talksData = [];
  final controller = ScrollController();

  final int _limit = 25;
  int _page = 1; // Le pagine iniziano da 1
  bool _isLoading = false;
  bool _hasMore = true;

  List<dynamic> get visibleTalksData {
    final query = widget.searchQuery.trim();
    if (query.isEmpty) {
      return talksData;
    }

    return talksData.where((talk) => SearchUtils.matchesTalk(talk as Map<String, dynamic>, query)).toList();
  }

  void _scrollListener() {
    if (_isLoading || !_hasMore || widget.searchQuery.isNotEmpty) return;

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
          if (!mounted) return;
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
    final items = visibleTalksData;

    return Stack(
      children: [
        talksData.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? Center(
                    child: Text(
                      widget.searchQuery.isEmpty
                          ? 'Nessun talk disponibile'
                          : 'Nessun talk trovato',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : Center(
                    child: ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.all(10),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final talk = items[index] as Map<String, dynamic>;
                        return TalkFeedCard(talkData: talk);
                      },
                    ),
                  ),

        // Pulsante assistente AI
        AiAssistantBtn(),
      ],
    );
  }
}
