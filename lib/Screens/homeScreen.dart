import 'package:flutter/material.dart';
import 'package:make_it/Models/toDoFilter.dart';
import 'package:make_it/Provider/Todo_Provider.dart';

import 'package:make_it/Widgets/ProggresCard.dart';
import 'package:make_it/Widgets/add_todo_sheet.dart';
import 'package:make_it/Widgets/appSvgIcon.dart';
import 'package:make_it/Widgets/filter_chips.dart';
import 'package:make_it/Widgets/swipeHint.dart';
import 'package:make_it/Widgets/todo_card.dart';
import 'package:make_it/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final String appName = 'Today';

  TodoFilter _selectedFilter = TodoFilter.all;

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final todos = todoProvider.todos;

    final complateCount = todoProvider.completedCount;
    final totalCount = todos.length;

    final now = DateTime.now();

    final filterTodo = todos.where((todo) {
      switch (_selectedFilter) {
        case TodoFilter.all:
          return true;
        case TodoFilter.today:
          return DateUtils.isSameDay(todo.dueDate, now);
        case TodoFilter.upcoming:
          return todo.dueDate.isAfter(DateTime(now.year, now.month, now.day)) &&
              !todo.isCompleted;

        case TodoFilter.completed:
          return todo.isCompleted;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF111827),
            barrierColor: Colors.black54,
            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: .vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return AddTodoSheet();
            },
          );
        },
        icon: AppSvgIcon(icon: Assets.icons.add),
        label: const Text('Yeni Görev'),
      ),

      body: CustomScrollView(
        slivers: [
          // Üst kısım: selamlama, özet kartı, filtreler
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Merhaba Hoş Geldin ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Assets.icons.hello.svg(width: 24, height: 24),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Progresscard(complate: complateCount, total: totalCount),

                  const SizedBox(height: 10),

                  ChipsFilter(
                    selected: _selectedFilter,
                    onSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),

                  const Swipehint(),
                ],
              ),
            ),
          ),

          if (filterTodo.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    todos.isEmpty
                        ? 'Henüz görev yok'
                        : 'Bu filtrede görev bulunamadı',
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              // Alt boşluk: son kart FAB'ın altında kalmasın.
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 88),
              sliver: SliverList.builder(
                itemCount: filterTodo.length,
                findChildIndexCallback: (key) {
                  final id = (key as ValueKey<String>).value;
                  final index = filterTodo.indexWhere((t) => t.id == id);
                  return index == -1 ? null : index;
                },
                itemBuilder: (context, index) {
                  final todo = filterTodo[index];
                  return Dismissible(
                    key: ValueKey(todo.id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF111827),
                          builder: (context) {
                            return AddTodoSheet(todos: todo);
                          },
                        );

                        // Düzenleme için kartı listeden kaldırma.
                        return false;
                      }

                      // Sola kaydırmada silme onaylanır.
                      return true;
                    },

                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        context.read<TodoProvider>().remove(todo.id);
                      }
                    },

                    child: TodoCard(
                      todoItem: todo,
                      onToggle: () {
                        context.read<TodoProvider>().toggle(todo.id);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
