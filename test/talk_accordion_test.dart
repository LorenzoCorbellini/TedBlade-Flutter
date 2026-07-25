import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tedblade_app/widgets/talks/talk_accordion.dart';

void main() {
  testWidgets('renders the description accordion with selectable content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TalkAccordion(
            transcript: Future.value(
              http.Response('{"data":{"transcript":"Transcript content"}}', 200),
            ),
            statistics: const {},
            description: 'This is the talk description.',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Description'), findsOneWidget);

    await tester.tap(find.text('Description'));
    await tester.pumpAndSettle();

    expect(find.text('This is the talk description.'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });
}
