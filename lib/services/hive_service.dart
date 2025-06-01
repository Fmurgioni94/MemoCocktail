import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import '../models/ingredient.dart';
import '../models/menu.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(IngredientAdapter());
    Hive.registerAdapter(CocktailAdapter());
    Hive.registerAdapter(MenuAdapter());

    final box = await Hive.openBox<Cocktail>('cocktails');

  }

  static Box<Cocktail> get cocktailBox => Hive.box<Cocktail>('cocktails');
}
 