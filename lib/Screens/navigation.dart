import 'package:flutter/material.dart';

import 'package:make_it/Screens/homescreen.dart';
import 'package:make_it/Screens/searchScreen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Sayfalar bir kez oluşturulur ve sekme değişimlerinde korunur.
  late final List<Widget> _pages = [const Homescreen(), SearchScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          if (index == _index) return;

          setState(() {
            _index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),

            label: 'Ana Sayfa',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Arama'),
        ],
      ),
    );
  }
}
