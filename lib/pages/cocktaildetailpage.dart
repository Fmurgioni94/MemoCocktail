import 'package:flutter/material.dart';
import '../models/cocktail.dart';

class CocktailDetailPage extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailDetailPage({super.key, required this.cocktail});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }

  Padding body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cocktail Name
          Center(
            child: Text(
              cocktail.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'ComicSans', // Or use a similar font
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Details Centered
          Text(cocktail.methodology, style: _infoStyle()),
          Text(cocktail.glass, style: _infoStyle()),
          Text(cocktail.ice, style: _infoStyle()),
          Text(cocktail.garnish, style: _infoStyle()),

          const SizedBox(height: 40),

          // Ingredients
          ...cocktail.ingredients.map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Text("•  ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    i.name,
                    style: _ingredientStyle(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(i.quantity, style: _ingredientStyle()),
              ],
            ),
          )),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Cocktail Details"),
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        ),
    );
  }

  TextStyle _infoStyle() {
    return const TextStyle(
      fontSize: 20,
      fontFamily: 'ComicSans', // Or another handwritten-style font
    );
  }

  TextStyle _ingredientStyle() {
    return const TextStyle(
      fontSize: 18,
      fontFamily: 'ComicSans',
    );
  }
  
  
}
