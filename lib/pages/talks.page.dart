import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tedblade_app/theme.dart';
import 'package:tedblade_app/fetch_utils.dart';
import 'package:tedblade_app/videofeedcard.dart';
import 'package:http/http.dart' as http;

class TalksPage extends StatefulWidget {
  final http.Client client;

  const TalksPage({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _TalksPageState();
  }
}

class _TalksPageState extends State<TalksPage> {
  List<dynamic> talksData = [];
  final controller = ScrollController();

  final int _limit = 10;
  int _page = 0;

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent - 100) {
      fetchNextTalksPage();
    }
  }

  void fetchNextTalksPage() {
    FetchUtils.fetchTalksPaginated(widget.client, _page++, _limit)
      .then((response) {
        if (!mounted) return;
        final body = jsonDecode(response.body);
        final talks = body['data'];

        setState(() {
          talksData.addAll(talks);
        });
      })
      .catchError((error) {
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
    // TODO: implement build
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
                      return VideoFeedCard(
                        title: talk['title'],
                        duration: talk['duration'],
                        views: talk['statistics'],
                        slug: talk['slug'],
                        thumbnailUrl: talk['thumbnail_url'],
                        speakers: talk['speakers'],
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
        Positioned(
          bottom: 16.0,
          left: 16.0,
          child: FloatingActionButton.small(
            onPressed: () {
              // TODO: implementare assistente AI
            },
            backgroundColor: AppTheme.colors.accent,
            elevation: 3,
            child: const Icon(
              Icons.auto_awesome_sharp,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
