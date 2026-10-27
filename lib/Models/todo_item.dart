import 'package:flutter/material.dart';

class TodoItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime dueDate;
  final TimeOfDay? dueTime;
  final bool isCompleted;

  const TodoItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.dueDate,
    this.dueTime,
    this.isCompleted = false,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    bool clearDueTime = false,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: clearDueTime ? null : dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'dueDate': dueDate.toIso8601String(),
    'dueHour': dueTime?.hour,
    'dueMinute': dueTime?.minute,
    'isCompleted': isCompleted,
  };

  factory TodoItem.fromMap(Map<String, dynamic> m) {
    final hour = m['dueHour'];
    final minute = m['dueMinute'];

    return TodoItem(
      id: m['id'] as String,
      title: m['title'] as String,
      description: (m['description'] as String?) ?? '',
      category: m['category'] as String,
      dueDate: DateTime.parse(m['dueDate'] as String),
      dueTime: hour == null || minute == null
          ? null
          : TimeOfDay(hour: hour as int, minute: minute as int),
      isCompleted: (m['isCompleted'] as bool?) ?? false,
    );
  }
}
