class SearchUtils {
  static bool matchesTalk(Map<String, dynamic> talk, String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final title = (talk['title'] ?? '').toString();
    return _normalize(title).contains(normalizedQuery);
  }

  static bool matchesSpeaker(Map<String, dynamic> speaker, String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final name = (speaker['speaker'] ?? '').toString();
    return _normalize(name).contains(normalizedQuery);
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}
