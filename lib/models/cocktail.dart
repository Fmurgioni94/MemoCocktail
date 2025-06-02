import 'package:hive/hive.dart';
import 'ingredient.dart';

part 'cocktail.g.dart';

@HiveType(typeId: 1)
class Cocktail {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String methodology;

  @HiveField(2)
  final String glass;

  @HiveField(3)
  final String ice;

  @HiveField(4)
  final String garnish;

  @HiveField(5)
  final List<Ingredient> ingredients;

  @HiveField(6)
  final String levelTag;

  @HiveField(7)
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
}
