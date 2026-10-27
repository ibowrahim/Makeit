import 'package:flutter/material.dart';
import 'package:make_it/Models/todo_item.dart';
import 'package:make_it/Widgets/todo_card.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, required this.todos, required this.onToggle});
  final List<TodoItem> todos;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(child: Text('Eşleşen Görev Bulunamadı'));
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return TodoCard(todoItem: todo, onToggle: () => onToggle(todo.id));
      },
    );
  }
}
