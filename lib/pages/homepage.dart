import 'package:MemoCocktail/pages/homepagecontent.dart';
import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/menus.dart';
import 'package:MemoCocktail/pages/settings.dart';
import 'package:MemoCocktail/pages/test.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; 
  List<Widget> _pages = const [
    HomePageContent(),
    Menus(),
    Test(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

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
    unselectedItemColor: Colors.white70,
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
        label: 'Test',
        icon: Icon(Icons.edit_note)
      ),
      BottomNavigationBarItem(
        label: 'Settings',
        icon: Icon(Icons.settings)
      )
    ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "MeMo Cocktail",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        ),
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate());
          },
           icon: const Icon(
            Icons.search,
            color: Colors.white,
            ),
        )
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> cocktailTitles = [
  'Harvard',
  'Mai Tai',
  'Clover Club',
  'Belafonte',
  'Stinger',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var cocktail in cocktailTitles) {
      if(cocktail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(cocktail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length, 
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result)
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var cocktail in cocktailTitles) {
      if(cocktail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(cocktail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length, 
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result)
        );
      },
    );
  }
}