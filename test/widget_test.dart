// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/pages/speakers/speakers_navigator.dart';

void main() {
  testWidgets('Speakers navigator supports the speaker-detail route', (WidgetTester tester) async {
    final client = http.Client();
    addTearDown(client.close);

    await tester.pumpWidget(
      MaterialApp(
        home: SpeakersNavigator(client: client),
      ),
    );

    await tester.pump();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator).last);

    expect(
      () => navigator.pushNamed(
        '/speaker-detail',
        arguments: {
          'name': 'Ada Lovelace',
          'thumbnail_url': '',
          'talkSlugs': [],
        },
      ),
      returnsNormally,
    );
  });
}
