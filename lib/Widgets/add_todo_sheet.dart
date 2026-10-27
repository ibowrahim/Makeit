import 'package:flutter/material.dart';
import 'package:make_it/Models/todo_category.dart';
import 'package:make_it/Models/todo_item.dart';
import 'package:make_it/Provider/Todo_Provider.dart';

import 'package:make_it/Services/notification_services.dart';
import 'package:make_it/Widgets/add_todo/task_category_selector.dart';
import 'package:make_it/Widgets/add_todo/task_date_time_sellection.dart';
import 'package:make_it/Widgets/add_todo/task_description_field.dart';
import 'package:make_it/Widgets/add_todo/tast_title_field.dart';
import 'package:make_it/Widgets/appSvgIcon.dart';
import 'package:make_it/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key, this.todos});

  final TodoItem? todos;

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  static const Color _background = Color(0xFF111827);
  static const Color _surface = Color(0xFF1F2937);
  static const Color _primary = Color(0xFF818CF8);
  static const Color _text = Color(0xFFF9FAFB);
  static const Color _muted = Color(0xFF9CA3AF);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  TodoCategory _selectedCategory = TodoCategory.work;

  @override
  void initState() {
    super.initState();

    final todo = widget.todos;

    if (todo != null) {
      titleController.text = todo.title;
      descriptionController.text = todo.description;

      _dueDate = todo.dueDate;
      _dueTime = todo.dueTime;

      _selectedCategory = TodoCategory.values.firstWhere(
        (category) => category.label == todo.category,
        orElse: () => TodoCategory.work,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst tutamaç
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Başlık
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: _primary,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yeni görev',
                          style: TextStyle(
                            color: _text,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Görev detaylarını belirle',
                          style: TextStyle(color: _muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Kapat',
                    style: IconButton.styleFrom(
                      backgroundColor: _surface,
                      foregroundColor: _muted,
                    ),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const _SectionLabel(title: 'Görev bilgileri'),
              const SizedBox(height: 12),

              TastTitleField(controller: titleController),

              const SizedBox(height: 12),

              TaskDescriptionField(controller: descriptionController),

              const SizedBox(height: 24),

              const _SectionLabel(title: 'Tarih ve saat'),
              const SizedBox(height: 12),

              TaskDateTimeSellection(
                onDateSelect: (date) {
                  setState(() {
                    _dueDate = date;
                  });
                },
                onTimeSelect: (time) {
                  setState(() {
                    _dueTime = time;
                  });
                },
              ),

              const SizedBox(height: 24),

              const _SectionLabel(title: 'Kategori'),
              const SizedBox(height: 12),

              TaskCategorySelector(
                selected: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Kaydet butonu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: _background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSvgIcon(icon: Assets.icons.add),
                      const SizedBox(width: 8),
                      const Text(
                        'Görevi Kaydet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTodo() async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen görev başlığını giriniz.')),
      );
      return;
    }

    final todo = TodoItem(
      id: widget.todos?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: descriptionController.text.trim(),
      category: _selectedCategory.label,
      dueDate: _dueDate ?? DateTime.now(),
      dueTime: _dueTime,
      isCompleted: widget.todos?.isCompleted ?? false,
    );

    final provider = context.read<TodoProvider>();
    final notifications = NotificationService();

    // Görev ID'sini Android bildirim ID'sine dönüştür.
    final notificationId = int.parse(todo.id) % 2147483647;

    // Görevin eski bildirimini kaldır.
    await notifications.cancelNotification(notificationId);

    // Görevi kaydet veya güncelle.
    if (widget.todos == null) {
      provider.add(todo);
    } else {
      provider.update(todo);
    }

    // Tamamlanmamış görevler için hatırlatıcı planla.
    if (!todo.isCompleted && todo.dueTime != null) {
      final dueDateTime = DateTime(
        todo.dueDate.year,
        todo.dueDate.month,
        todo.dueDate.day,
        todo.dueTime!.hour,
        todo.dueTime!.minute,
      );

      // Görevden 15 dakika önce bildirim gönder.
      final reminderTime = dueDateTime.subtract(const Duration(minutes: 15));

      if (reminderTime.isAfter(DateTime.now())) {
        try {
          await notifications.requestPermissions();

          await notifications.scheduleNotification(
            id: notificationId,
            title: 'Görev zamanı yaklaşıyor',
            body: todo.title,
            scheduledDate: reminderTime,
          );
        } catch (error, stackTrace) {
          debugPrint('Bildirim planlama hatası: $error');
          debugPrintStack(stackTrace: stackTrace);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Görev kaydedildi ancak bildirim planlanamadı.'),
              ),
            );
          }
        }
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFF9FAFB),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
