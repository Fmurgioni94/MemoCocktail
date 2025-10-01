import 'ingredient.dart';

class Cocktail {
  final String name;
  final String methodology;
  final String glass;
  final String ice;
  final String garnish;
  final List<Ingredient> ingredients;
  final String levelTag;
  final String notes;

  Cocktail({
    required this.name,
    required this.methodology,
    required this.glass,
    required this.ice,
    required this.garnish,
    required this.ingredients,
    required this.levelTag,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'methodology': methodology,
      'glass': glass,
      'ice': ice,
      'garnish': garnish,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'levelTag': levelTag,
      'notes': notes,
    };
  }

  factory Cocktail.fromMap(Map<String, dynamic> map) {
    final ingredientsData = (map['ingredients'] as List<dynamic>? ?? []);
    return Cocktail(
      name: map['name'] as String? ?? '',
      methodology: map['methodology'] as String? ?? '',
      glass: map['glass'] as String? ?? '',
      ice: map['ice'] as String? ?? '',
      garnish: map['garnish'] as String? ?? '',
      ingredients: ingredientsData
          .map((e) => Ingredient.fromMap(e as Map<String, dynamic>))
          .toList(),
      levelTag: map['levelTag'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }
}
