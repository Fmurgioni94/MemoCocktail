import '../models/cocktail.dart';
import '../models/ingredient.dart';
import '../services/hive_service.dart';

Future<void> insertInitialCocktails() async {
  final cocktails = <Cocktail>[
    Cocktail(
      name: 'Harvard',
      methodology: 'Stir',
      glass: 'Nick&Nora',
      ice: 'Up',
      garnish: 'None',
      ingredients: [
        Ingredient(name: 'Hennessy VSOP', quantity: '50 ml'),
        Ingredient(name: 'Sweet vermouth', quantity: '25 ml'),
        Ingredient(name: 'Angostura', quantity: '3 dashes'),
        Ingredient(name: 'Soda', quantity: 'Splash'),
      ],
    ),
    Cocktail(
      name: 'Mai Tai',
      methodology: 'Shake',
      glass: 'Rocks',
      ice: 'Crushed',
      garnish: 'Spent half of lime (dome up) & Mint sprig',
      ingredients: [
        Ingredient(name: 'Smith & Cross', quantity: '20 ml'),
        Ingredient(name: 'Appleton 12 yo', quantity: '20 ml'),
        Ingredient(name: 'Lime juice', quantity: '20 ml'),
        Ingredient(name: 'Orange curaçao', quantity: '10 ml'),
        Ingredient(name: 'Orgeat', quantity: '10 ml'),
      ],
    ),
    Cocktail(
      name: 'Clover Club',
      methodology: 'Double shake',
      glass: 'Coupe',
      ice: 'Up',
      garnish: 'None',
      ingredients: [
        Ingredient(name: 'Eight lands gin', quantity: '50 ml'),
        Ingredient(name: 'Dry vermouth', quantity: '25 ml'),
        Ingredient(name: 'Lemon juice', quantity: '25 ml'),
        Ingredient(name: 'Raspberry syrup', quantity: '15 ml'),
        Ingredient(name: 'Egg white', quantity: '20 ml'),
      ],
    ),
    Cocktail(
      name: 'Belafonte',
      methodology: 'Build',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Orange twist',
      ingredients: [
        Ingredient(name: 'Campari', quantity: '30 ml'),
        Ingredient(name: 'White port', quantity: '30 ml'),
        Ingredient(name: 'Tonic water', quantity: 'Top up'),
      ],
    ),
    Cocktail(
      name: 'Stinger',
      methodology: 'Stir',
      glass: 'Nick&Nora',
      ice: 'Up',
      garnish: 'None',
      ingredients: [
        Ingredient(name: 'Eight lands vodka', quantity: '50 ml'),
        Ingredient(name: 'White creme de menthe', quantity: '25 ml'),
      ],
    ),
  ];

  final box = HiveService.cocktailBox;

  for (var cocktail in cocktails) {
    // Avoid duplication
    if (!box.containsKey(cocktail.name)) {
      await box.put(cocktail.name, cocktail);
    }
  }
}
