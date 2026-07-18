import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/pages/speakers/speaker_details.dart';
import 'package:tedblade_app/pages/speakers/speakers_feed.dart';

class SpeakersNavigator extends StatefulWidget {
  final http.Client client;

  const SpeakersNavigator({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _SpeakersNavigatorState();
  }
}

class _SpeakersNavigatorState extends State<SpeakersNavigator> {
  final GlobalKey<NavigatorState> _speakersNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final NavigatorState? navigator = _speakersNavigatorKey.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Navigator(
        key: _speakersNavigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          
          switch (settings.name) {
            case '/':
              // Show feed page
              builder = (BuildContext context) => SpeakersFeed(client: widget.client);
              break;
            case '/detail':
              // Show speaker details page
              final args = settings.arguments as Map<String, dynamic>?;
              builder = (BuildContext context) => SpeakerDetails(speakerData: args ?? {});
              break;
            default:
              throw Exception('Unknown route: ${settings.name}');
          }
          
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      );
  }
}