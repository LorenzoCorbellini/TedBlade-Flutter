import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/pages/talks/talk_details.dart';
import 'package:tedblade_app/pages/talks/talks_feed.dart';

class TalksNavigator extends StatefulWidget {
  final http.Client client;

  const TalksNavigator({super.key, required this.client});

  @override
  State<StatefulWidget> createState() {
    return _TalksNavigatorState();
  }
}

class _TalksNavigatorState extends State<TalksNavigator> {
  final GlobalKey<NavigatorState> _talksNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final NavigatorState? navigator = _talksNavigatorKey.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Navigator(
        key: _talksNavigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          
          switch (settings.name) {
            case '/':
              // Show feed page
              builder = (BuildContext context) => TalksFeed(client: widget.client);
              break;
            case '/detail':
              // Show talk details page
              final args = settings.arguments as Map<String, dynamic>?;
              builder = (BuildContext context) => TalkDetails(talkData: args ?? {});
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