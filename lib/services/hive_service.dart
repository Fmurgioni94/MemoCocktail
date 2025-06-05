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

    // await Hive.openBox<Cocktail>('cocktails');
    // await Hive.openBox<Menu>('menus');
    final cocktailBox = await Hive.openBox<Cocktail>('cocktails');
    final menuBox = await Hive.openBox<Menu>('menus');
    await cocktailBox.clear();
    await menuBox.clear();
    // await insertInitialMenus();
  }

  static Box<Cocktail> get cocktailBox => Hive.box<Cocktail>('cocktails');
  static Box<Menu> get menuBox => Hive.box<Menu>('menus');
}
 