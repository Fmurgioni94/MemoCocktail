import 'package:hive/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 0)
class Ingredient {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}
