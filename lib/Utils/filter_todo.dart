import 'package:make_it/Models/toDoFilter.dart';
import 'package:make_it/Models/todo_item.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

List<TodoItem> filterTodo(
  List<TodoItem> todos,
  TodoFilter filter,
  DateTime now,
) {
  final today = dateOnly(now);
  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.completed:
      return todos.where((t) => t.isCompleted).toList();
    case TodoFilter.today:
      return todos.where((t) => dateOnly(t.dueDate) == today).toList();
    case TodoFilter.upcoming:
      return todos
          .where((t) => !t.isCompleted && dateOnly(t.dueDate).isAfter(today))
          .toList();
  }
}
