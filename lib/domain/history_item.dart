abstract class HistoryRepository {
  Future<void> insertHistory(String text);
  Future<List<HistoryItem>> getHistory();
}

class HistoryItem {
  final String text;
  final String createdAt;

  HistoryItem({required this.text, required this.createdAt});
}
