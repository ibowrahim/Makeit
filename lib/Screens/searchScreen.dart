import 'package:flutter/material.dart';
import 'package:make_it/Provider/Todo_Provider.dart';
import 'package:make_it/Services/search_hisroty.dart';
import 'package:make_it/Widgets/search_todo/recent_search.dart';
import 'package:make_it/Widgets/search_todo/search_field.dart';
import 'package:make_it/Widgets/search_todo/search_result.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  List<String> _searchHistory = [];
  SearchHisroty search = SearchHisroty();

  final TextEditingController _searchHistoryControler = TextEditingController();

  Future<void> _loadSearchHistory() async {
    final history = await search.loadHistory();

    if (!mounted) return;

    setState(() {
      _searchHistory = history;
    });
  }

  void _onSearchChange(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onSubmitted(String value) async {
    final query = value.trim();

    if (query.isEmpty) return;

    await search.addSearch(query);

    if (!mounted) return;

    setState(() {
      _searchQuery = value.trim();
    });
    await _loadSearchHistory();
  }

  void _onRecentSearchSelect(String value) {
    _searchHistoryControler.text = value;
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _clearSearchHistory() async {
    await search.clearHistory();
    if (!mounted) return;

    setState(() {
      _searchHistory = [];
    });
  }

  @override
  void initState() {
    _loadSearchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final query = _searchQuery.trim().toLowerCase();

    final filteredTodos = todoProvider.todos.where((todo) {
      return todo.title.toLowerCase().contains(query) ||
          todo.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(onChanged: _onSearchChange, onSubmtted: _onSubmitted),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: query.isEmpty
                      ? RecentSearch(
                          key: const ValueKey('recent_search'),
                          search: _searchHistory,
                          onSearchSelect: _onRecentSearchSelect,
                          onClear: _clearSearchHistory,
                        )
                      : SearchResult(
                          key: const ValueKey('search_result'),
                          todos: filteredTodos,
                          onToggle: (id) {
                            context.read<TodoProvider>().toggle(id);
                          },
                        ),
                ),
              ),
              SizedBox(height: 20),
              RecentSearch(
                search: _searchHistory,
                onSearchSelect: _onRecentSearchSelect,
                onClear: _clearSearchHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
