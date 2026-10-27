
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:make_it/Models/todo_item.dart';
import 'package:make_it/Services/todo_services.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider({TodoStorage? storage})
      : _storage = storage ?? TodoStorage() {
    _lastCheckedDate = _dateOnly(DateTime.now());

    _dayTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkDateChanged(),
    );
  }

  final TodoStorage _storage;
  final List<TodoItem> _todos = [];

  bool _isLoading = true;
  late DateTime _lastCheckedDate;
  Timer? _dayTimer;

  List<TodoItem> get todos => List.unmodifiable(_todos);

  bool get isLoading => _isLoading;

  // Uygulamadaki tüm görevlerin tamamlanan sayısı.
  int get completedCount =>
      _todos.where((todo) => todo.isCompleted).length;

  // Yalnızca bugünün görevleri.
  List<TodoItem> get todayTodos {
    final today = _dateOnly(DateTime.now());

    return _todos.where((todo) {
      return _dateOnly(todo.dueDate) == today;
    }).toList();
  }

  int get todayTotalCount => todayTodos.length;

  int get todayCompletedCount =>
      todayTodos.where((todo) => todo.isCompleted).length;

  int get todayRemainingCount =>
      todayTotalCount - todayCompletedCount;

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _checkDateChanged() {
    final today = _dateOnly(DateTime.now());

    if (today != _lastCheckedDate) {
      _lastCheckedDate = today;
      notifyListeners();
    }
  }

  Future<void> load() async {
    final loadedTodos = await _storage.load();

    _todos
      ..clear()
      ..addAll(_removeDuplicateIds(loadedTodos));

    _isLoading = false;

    await _storage.save(_todos);

    _lastCheckedDate = _dateOnly(DateTime.now());
    notifyListeners();
  }

  List<TodoItem> _removeDuplicateIds(List<TodoItem> todos) {
    final seenIds = <String>{};

    return todos.where((todo) {
      return seenIds.add(todo.id);
    }).toList();
  }

  void toggle(String id) {
    final i = _todos.indexWhere((todo) => todo.id == id);
    if (i == -1) return;

    _todos[i] = _todos[i].copyWith(
      isCompleted: !_todos[i].isCompleted,
    );

    notifyListeners();
    _storage.save(_todos);
  }

  void add(TodoItem todo) {
    if (_todos.any((item) => item.id == todo.id)) return;

    _todos.insert(0, todo);

    notifyListeners();
    _storage.save(_todos);
  }

  void update(TodoItem updated) {
    final i = _todos.indexWhere((todo) => todo.id == updated.id);
    if (i == -1) return;

    _todos[i] = updated;

    notifyListeners();
    _storage.save(_todos);
  }

  void remove(String id) {
    _todos.removeWhere((todo) => todo.id == id);

    notifyListeners();
    _storage.save(_todos);
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    super.dispose();
  }
}
