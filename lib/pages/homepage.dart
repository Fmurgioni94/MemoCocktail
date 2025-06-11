import 'package:MemoCocktail/pages/databasecomunicationpage.dart';
import 'package:MemoCocktail/pages/homepagecontent.dart';
import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/menus.dart';
import 'package:MemoCocktail/pages/settings.dart';
import 'package:MemoCocktail/pages/test.dart';


import 'package:hive/hive.dart';
import '../models/cocktail.dart';
import '../pages/cocktaildetailpage.dart'; // Adjust path if needed

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
    Test(),
    Settings(),
    Databasecomunicationpage(),
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
        label: 'Test',
        icon: Icon(Icons.edit_note)
      ),
      BottomNavigationBarItem(
        label: 'Settings',
        icon: Icon(Icons.settings)
      ),
      BottomNavigationBarItem(
        label: 'Data-Base',
        icon: Icon(Icons.data_usage)
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
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  Widget _buildResultsOrSuggestions(BuildContext context) {
    final cocktailBox = Hive.box<Cocktail>('cocktails');

    final cocktails = cocktailBox.values
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (cocktails.isEmpty) {
      return const Center(child: Text("No cocktails found."));
    }

    return ListView.builder(
      itemCount: cocktails.length,
      itemBuilder: (context, index) {
        final cocktail = cocktails[index];
        return ListTile(
          title: Text(cocktail.name),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CocktailDetailPage(cocktail: cocktail),
              ),
            );
          },
        );
      },
    );
  }
}
