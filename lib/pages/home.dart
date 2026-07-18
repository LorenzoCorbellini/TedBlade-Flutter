import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/pages/speakers/speakers_navigator.dart';
import 'package:tedblade_app/pages/talks/talks_navigators.dart';
import 'package:tedblade_app/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final client = http.Client();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
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

      body: IndexedStack(
        index: _index,
        children: [
          TalksNavigator(client: client),
          SpeakersNavigator(client: client),
        ],
      ),

      // Pulsante con lente d'ingrandimento
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: implementare ricerca
        },
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
