import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import 'cocktaildetailpage.dart';
import 'package:hive/hive.dart';

class MenuCocktailListPage extends StatelessWidget {
  final Menu menu;
  const MenuCocktailListPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final cocktailBox = Hive.box<Cocktail>('cocktails');
    // Find cocktails by name
    final cocktails = menu.cocktailsNames
        .where((name) => cocktailBox.values.any((c) => c.name == name))
        .map((name) => cocktailBox.values.firstWhere((c) => c.name == name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          menu.title.toUpperCase(),
          style: TextStyle(
            color: Colors.white
          ),
          ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: cocktails.length,
        itemBuilder: (context, index) {
          final cocktail = cocktails[index];
          return ListTile(
            title: Text(cocktail.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CocktailDetailPage(cocktail: cocktail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}