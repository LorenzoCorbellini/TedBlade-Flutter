import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/pages/speakers/speakers_navigator.dart';
import 'package:tedblade_app/pages/talks/talks_navigator.dart';
import 'package:tedblade_app/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final client = http.Client();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    client.close();
    super.dispose();
  }

  Future<void> _openSearchDialog() async {
    _searchController.text = _searchQuery;

    final shouldSearch = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerca contenuti'),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Scrivi il titolo o il nome...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => Navigator.of(dialogContext).pop(true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cerca'),
            ),
          ],
        );
      },
    );

    if (shouldSearch != true) return;

    final query = _searchController.text.trim();
    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TedBlade',
          style: AppTheme.text.bold.copyWith(fontSize: 32),
        ),
        backgroundColor: AppTheme.colors.secondary,
      ),

      body: Stack(
        children: [
          IndexedStack(
            index: _index,
            children: [
              TalksNavigator(client: client, searchQuery: _searchQuery),
              SpeakersNavigator(client: client, searchQuery: _searchQuery),
            ],
          ),
          if (_isSearching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.12),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openSearchDialog,
        backgroundColor: Colors.white,
        elevation: 3,
        shape: const CircleBorder(),
        child: const Icon(Icons.search, size: 36, color: Colors.black),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: AppTheme.text.regular.copyWith(fontSize: 14),
        unselectedLabelStyle: AppTheme.text.regular.copyWith(fontSize: 12),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Talks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Speakers'),
        ],
        selectedItemColor: AppTheme.colors.accent,
        currentIndex: _index,
        onTap: (index) {
          setState(() => _index = index);
        },
      ),
    );
  }
}
