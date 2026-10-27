import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:make_it/Models/todo_item.dart';

class TodoStorage {
  static const _key = 'todos';

  Future<List<TodoItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => TodoItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return []; // bozuk veri uygulamayı çökertmesin
    }
  }

  Future<void> save(List<TodoItem> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(todos.map((t) => t.toMap()).toList());
    await prefs.setString(_key, raw);
  }
}