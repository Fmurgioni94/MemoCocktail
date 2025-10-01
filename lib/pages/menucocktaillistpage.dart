import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import 'cocktaildetailpage.dart';
import '../services/firestore_service.dart';

class MenuCocktailListPage extends StatelessWidget {
  final Menu menu;
  const MenuCocktailListPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    // Find cocktails by name from Firestore snapshot
    // We load all cocktails once via stream and filter by name
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
      body: StreamBuilder<List<Cocktail>>(
        stream: FirestoreService.watchCocktails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = snapshot.data!;
          final cocktails = menu.cocktailsNames
              .map((name) => all.firstWhere(
                    (c) => c.name == name,
                    orElse: () =>
                        Cocktail(name: name, methodology: '', glass: '', ice: '', garnish: '', ingredients: const [], levelTag: '', notes: ''),
                  ))
              .where((c) => c.methodology.isNotEmpty || c.glass.isNotEmpty)
              .toList();
          if (cocktails.isEmpty) {
            return const Center(child: Text('No cocktails found in this menu.'));
          }
          return ListView.builder(
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
          );
        },
      ),
    );
  }
}