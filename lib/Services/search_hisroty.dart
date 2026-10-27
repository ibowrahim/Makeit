

import 'package:shared_preferences/shared_preferences.dart';

class SearchHisroty {
  static const String _storageKey = 'search_history';

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> addSearch(String query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final histosry = prefs.getStringList(_storageKey) ?? [];

    histosry.removeWhere(
      (item) => item.toLowerCase() == cleanedQuery.toLowerCase(),
    );

    histosry.insert(0, cleanedQuery);

    if (histosry.length > 10) {
      histosry.removeRange(10, histosry.length);
    }

    await prefs.setStringList(_storageKey, histosry);
  }


  Future<void> clearHistory() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

}
