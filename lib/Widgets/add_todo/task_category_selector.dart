import 'package:flutter/material.dart';
import 'package:make_it/Models/todo_category.dart';

class TaskCategorySelector extends StatelessWidget {
  const TaskCategorySelector({
    super.key,
    required this.onCategorySelected,
    required this.selected,
  });

  final TodoCategory selected;
  final ValueChanged<TodoCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final category in TodoCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: category == selected ? colors.primary : colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: category == selected
                        ? colors.primary
                        : colors.outlineVariant.withValues(alpha: 0),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onCategorySelected(category),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: category == selected
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant.withValues(
                                      alpha: 0.55,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: category == selected
                                  ? colors.onPrimary
                                  : colors.onSurface,
                              fontWeight: category == selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                          if (category == selected) ...[
                            const SizedBox(width: 7),
                            Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: colors.onPrimary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
