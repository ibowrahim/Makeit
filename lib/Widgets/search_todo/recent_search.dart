import 'package:flutter/material.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({
    super.key,
    required this.search,
    required this.onSearchSelect,
    required this.onClear,
  });

  final List<String> search;
  final ValueChanged<String> onSearchSelect;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (search.isEmpty) {
      return Center(child: Text('Henüz arama geçmişi yok'));
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Son aramalar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(onPressed: onClear, child: Text('Temizle')),
          ],
        ),

        SizedBox(height: 8),

        ...search.map(
          (search) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history),
            title: Text(search),
            trailing: const Icon(Icons.north_west, size: 18),
            onTap: () => onSearchSelect(search),
          ),
        ),
      ],
    );
  }
}
