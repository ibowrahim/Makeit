import 'package:flutter/material.dart';
import 'package:make_it/Models/todo_item.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todoItem;
  final VoidCallback onToggle;

  const TodoCard({super.key, required this.todoItem, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = todoItem.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: done
            ? scheme.surfaceContainer.withValues(alpha: 0.5)
            : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Soldaki renkli çizgi
          Positioned(
            left: 6,
            top: 14,
            bottom: 14,
            width: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              AnimatedScale(
                scale: done ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: Checkbox(
                  value: done,
                  onChanged: (value) => onToggle(),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 14, 12),
                  child: _Header(
                    title: todoItem.title,
                    catagory: todoItem.category,
                    date: todoItem.dueDate,
                    time: todoItem.dueTime,
                    color: scheme.secondaryContainer,
                    done: done,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String catagory;
  final DateTime date;
  final TimeOfDay? time;
  final Color color;
  final bool done;

  const _Header({
    required this.title,
    required this.catagory,
    required this.date,
    required this.time,
    required this.color,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dateText = MaterialLocalizations.of(context).formatShortDate(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            decorationThickness: 3.5,
            decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
            color: done ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
          child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Kategori
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                catagory,
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Tarih: her zaman görünür
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  dateText,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            // Saat: yalnızca seçilmişse görünür
            if (time != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time!.format(context),
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
