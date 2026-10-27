import 'package:flutter/material.dart';
import 'package:make_it/Models/toDoFilter.dart';

class ChipsFilter extends StatelessWidget {
  final TodoFilter selected;
  final ValueChanged<TodoFilter> onSelected;
  const ChipsFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final filter in TodoFilter.values)
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: filter == selected,
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }
}
