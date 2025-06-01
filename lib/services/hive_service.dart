import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import '../models/ingredient.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(IngredientAdapter());
    Hive.registerAdapter(CocktailAdapter());

    final box = await Hive.openBox<Cocktail>('cocktails');

    // ✅ Print the storage path for debugging
    print('Hive storage path: ${box.path}');
  }

  static Box<Cocktail> get cocktailBox => Hive.box<Cocktail>('cocktails');
}
 