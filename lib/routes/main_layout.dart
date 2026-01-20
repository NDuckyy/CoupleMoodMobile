import 'package:couple_mood_mobile/screens/home/home_screen.dart';
import 'package:couple_mood_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // MapPage(),
    // SearchPage(),
    HomeScreen(),
    // WorldPage(),
    // CollectionPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.local_fire_department_rounded),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 6),
            ),
            IconButton(
              icon: const Icon(Icons.chat_outlined),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            IconButton(
              icon: const Icon(Icons.home_outlined),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: const Icon(Icons.south_america_outlined),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 4),
            ),
            IconButton(
              icon: const Icon(Icons.collections_outlined),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 5),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              color: Color(0xFF7B8CE4),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }
}
