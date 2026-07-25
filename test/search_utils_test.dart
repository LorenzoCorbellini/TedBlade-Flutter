import 'package:flutter_test/flutter_test.dart';
import 'package:tedblade_app/search_utils.dart';

void main() {
  group('SearchUtils', () {
    test('matches talks by partial and case-insensitive title', () {
      final talk = {'title': 'Building AI for Everyone'};

      expect(SearchUtils.matchesTalk(talk, 'ai'), isTrue);
      expect(SearchUtils.matchesTalk(talk, 'BUILD'), isTrue);
      expect(SearchUtils.matchesTalk(talk, 'for everyone'), isTrue);
      expect(SearchUtils.matchesTalk(talk, 'robotics'), isFalse);
    });

    test('matches speakers by partial and case-insensitive name', () {
      final speaker = {'speaker': 'Ada Lovelace'};

      expect(SearchUtils.matchesSpeaker(speaker, 'ada'), isTrue);
      expect(SearchUtils.matchesSpeaker(speaker, 'LOVELACE'), isTrue);
      expect(SearchUtils.matchesSpeaker(speaker, 'da lo'), isTrue);
      expect(SearchUtils.matchesSpeaker(speaker, 'grace'), isFalse);
    });
  });
}
