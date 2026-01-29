import 'package:flutter/material.dart';
import 'sermons/sermons_screen.dart';
import 'ministration/ministration_screen.dart';
import 'about/about_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [
    SermonsScreen(),
    MinistrationScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.play_circle),
            label: 'Prédicas',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_agent),
            label: 'Ministración',
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'Acerca',
          ),
        ],
      ),
    );
  }
}
