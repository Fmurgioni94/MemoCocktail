import 'package:MemoCocktail/pages/homepagecontent.dart';
import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/menus.dart';
import 'package:MemoCocktail/pages/training.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; 
  final List<Widget> _pages = const [
    Homepagecontent(),
    Menus(),
    Training()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Center body() => Center(
    child: _pages[_selectedIndex],
    );

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (int newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      },
    backgroundColor: Colors.deepPurpleAccent,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(
        label: 'Home',
        icon: Icon(Icons.home)
      ),
      BottomNavigationBarItem(
        label: 'Menus',
        icon: Icon(Icons.menu_book)
      ),
      BottomNavigationBarItem(
        label: 'Train',
        icon: Icon(Icons.psychology)
      )
    ],
    );
  }
}


