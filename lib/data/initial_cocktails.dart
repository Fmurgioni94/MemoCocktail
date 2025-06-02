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
      name: 'Salamanca',
      methodology: 'Shaken',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'Lime wheel',
      ingredients: [
        Ingredient(name: 'Tapatio blanco', quantity: '40 ml'),
        Ingredient(name: 'Lime juice', quantity: '20 ml'),
        Ingredient(name: 'White creme de cacao', quantity: '20 ml'),
        Ingredient(name: 'Martini Ambrato', quantity: '20 ml'),
      ],
    ),
    Cocktail(
      name: 'Mamba',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Everleaf Mountain', quantity: '50 ml'),
        Ingredient(name: 'Raspberry syrup', quantity: '15 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '10 ml'),
        Ingredient(name: 'Tabasco', quantity: '20 drops'),
        Ingredient(name: 'Slim Tonic', quantity: 'Splash'),
      ],
    ),

    Cocktail(
      name: 'Virgin Pennicciline',
      methodology: 'Shaken',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Everleaf forest', quantity: '60 ml'),
        Ingredient(name: 'Honey Sage & Chilli syrup', quantity: '25 ml'),
        Ingredient(name: 'Lemon juice', quantity: '25 ml'),
        Ingredient(name: 'Ginger Beer', quantity: 'Top up'),
      ],
    ),

    Cocktail(
      name: 'Forest for the Trees',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Lemon discard',
      ingredients: [
        Ingredient(name: 'Everleaf forest', quantity: '50 ml'),
        Ingredient(name: 'Orange & green tea cordial', quantity: '20 ml'),
        Ingredient(name: 'Lemon juice', quantity: '10 ml'),
        Ingredient(name: 'Ginger ale', quantity: 'Top up'),
      ],
    ),

    Cocktail(
      name: 'Roachester',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Dehydrated Pineapple',
      ingredients: [
        Ingredient(name: 'Seedlip infused jalapeño', quantity: '50 ml'),
        Ingredient(name: 'Pineapple tea', quantity: '50 ml'),
        Ingredient(name: 'Passion fruit purea', quantity: '25 ml'),
        Ingredient(name: 'Agave water', quantity: '5 ml'),
        Ingredient(name: 'Lemonade', quantity: 'Top up'),
      ],
    ),

    Cocktail(
      name: 'The EBP',
      methodology: 'Shaken',
      glass: 'Rock',
      ice: 'Block',
      garnish: 'Half salt rim',
      ingredients: [
        Ingredient(name: 'Seedlip spice', quantity: '50 ml'),
        Ingredient(name: 'Lime juice', quantity: '25 ml'),
        Ingredient(name: 'Agave water', quantity: '25 ml'),
        Ingredient(name: 'Tabasco', quantity: '3 dashes'),
      ],
    ),

    Cocktail(
      name: 'Harabell Spritz',
      methodology: 'Build',
      glass: 'Rocks',
      ice: 'Cubed',
      garnish: 'Cucumber slice',
      ingredients: [
        Ingredient(name: 'Prosecco', quantity: '50 ml'),
        Ingredient(name: 'Pomello', quantity: '25 ml'),
        Ingredient(name: 'Grapefruit juice', quantity: '20 ml'),
        Ingredient(name: 'Raspberry & Cucumber shrub', quantity: '10 ml'),
        Ingredient(name: 'Soda', quantity: 'Splash'),
      ],
    ),

    Cocktail(
      name: 'Bordoni',
      methodology: 'Stirred',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'Grapefruit twist',
      ingredients: [
        Ingredient(name: 'Seedlip spice', quantity: '40 ml'),
        Ingredient(name: 'Bordeaux amaro', quantity: '25 ml'),
        Ingredient(name: 'Campari', quantity: '15 ml'),
        Ingredient(name: 'Orange bitter', quantity: '2 dashes'),
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
    Cocktail(
      name: 'Ichijiku',
      methodology: 'Build',
      glass: 'Thin Highball',
      ice: 'Block/2',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Chita', quantity: '40 ml'),
        Ingredient(name: 'Fig Liquer', quantity: '10 ml'),
        Ingredient(name: 'Yuzu Aperitif', quantity: 'Spray'),
        Ingredient(name: 'Soda', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Umeomaru',
      methodology: 'Build',
      glass: 'Thin Highball',
      ice: 'Block/2',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Toki', quantity: '40 ml'),
        Ingredient(name: 'Akashi Tai Umeshu', quantity: '20 ml'),
        Ingredient(name: 'Shiso Syrup', quantity: '10 ml'),
        Ingredient(name: 'Soda', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Hishicari',
      methodology: 'Throw',
      glass: 'Thin Highball',
      ice: 'Block/2',
      garnish: 'Dry Yuzu powder',
      ingredients: [
        Ingredient(name: 'Hibiki Armony', quantity: '50 ml'),
        Ingredient(name: 'Chay tea cordial', quantity: '30 ml'),
        Ingredient(name: 'Soda', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Hato',
      methodology: 'Shaken',
      glass: 'Thin Rock',
      ice: 'Block',
      garnish: 'Shiso Leaf',
      ingredients: [
        Ingredient(name: 'Bruxo Mezcal', quantity: '30 ml'),
        Ingredient(name: 'Sakura Vermouth', quantity: '30 ml'),
        Ingredient(name: 'Yuzu Juice', quantity: '15 ml'),
        Ingredient(name: 'Shiso Syrup', quantity: '15 ml'),
        Ingredient(name: 'Salt', quantity: 'Pinch'),
      ],
    ),

    Cocktail(
      name: 'Nisshoki',
      methodology: 'Stirred',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'Sesame Oil & Ponzu sauce',
      ingredients: [
        Ingredient(name: 'Haku infused wasabi', quantity: '35 ml'),
        Ingredient(name: 'Sake', quantity: '35 ml'),
      ],
    ),

    Cocktail(
      name: 'Katana 75',
      methodology: 'Shaken',
      glass: 'Flute',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Roku', quantity: '30 ml'),
        Ingredient(name: 'Mandarin Napoleon', quantity: '20 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '15 ml'),
        Ingredient(name: 'Yuzu Juice', quantity: '10 ml'),
        Ingredient(name: 'Sugar Syrup', quantity: '10 ml'),
        Ingredient(name: 'Champagne', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Hokusai Special',
      methodology: 'Shaken',
      glass: 'Coupe',
      ice: 'Up',
      garnish: 'Red Currant on rim',
      ingredients: [
        Ingredient(name: 'Toki', quantity: '45 ml'),
        Ingredient(name: 'Akashi Tai Umeshu', quantity: '45 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '15 ml'),
        Ingredient(name: 'Red Currant Syrup', quantity: '15 ml'),
      ],
    ),

    Cocktail(
      name: 'Shibuya',
      methodology: 'Stirred',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'Lemon Twist',
      ingredients: [
        Ingredient(name: 'Miso Buttered Toki', quantity: '35 ml'),
        Ingredient(name: 'Sweet Vermouth', quantity: '35 ml'),
      ],
    ),

    Cocktail(
      name: 'Chanoyu',
      methodology: 'Shaken',
      glass: 'Ceramic Cup',
      ice: 'Block',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Haku', quantity: '45 ml'),
        Ingredient(name: 'Lime Juice', quantity: '25 ml'),
        Ingredient(name: 'Koko Kanu', quantity: '15 ml'),
        Ingredient(name: 'Matcha Syrup', quantity: '15 ml'),
        Ingredient(name: 'Soda', quantity: 'Top Up'),
      ],
    ),Cocktail(
      name: 'To Kill a Sunrise',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Slice of orange bottom & one on top',
      ingredients: [
        Ingredient(name: 'Tapatio reposado', quantity: '60 ml'),
        Ingredient(name: 'Lime juice', quantity: '30 ml'),
        Ingredient(name: 'Orange curaçao', quantity: '20 ml'),
        Ingredient(name: 'Cinnamon syrup', quantity: '20 ml'),
        Ingredient(name: 'Grenadine', quantity: '2.5 ml'),
      ],
    ),

    Cocktail(
      name: 'Harvey Doorbanger',
      methodology: 'Shenken',
      glass: 'Coupe',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Belvedere', quantity: '40 ml'),
        Ingredient(name: 'Orange cordial', quantity: '35 ml'),
        Ingredient(name: 'Galliano', quantity: '5 ml'),
        Ingredient(name: 'Boker’s Bitter', quantity: '2.5 ml'),
      ],
    ),

    Cocktail(
      name: 'Wrong Island Ice Tea',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cube',
      garnish: 'Long lemon peel',
      ingredients: [
        Ingredient(name: 'Clarin SonSon', quantity: '15 ml'),
        Ingredient(name: 'Italicus', quantity: '15 ml'),
        Ingredient(name: 'Pisco', quantity: '15 ml'),
        Ingredient(name: 'Tapatio blanco', quantity: '15 ml'),
        Ingredient(name: 'Belvedere', quantity: '15 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '20 ml'),
        Ingredient(name: 'Cinnamon Syrup', quantity: '10 ml'),
        Ingredient(name: 'Earl Grey tea', quantity: 'Floating'),
      ],
    ),

    Cocktail(
      name: 'Stepfather',
      methodology: 'Stirred',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Woodford Reserve', quantity: '40 ml'),
        Ingredient(name: 'Almond Grappa', quantity: '25 ml'),
        Ingredient(name: 'Maraschino Syrup', quantity: '5 ml'),
      ],
    ),

    Cocktail(
      name: 'Daisy Duke',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Casamigos Silver', quantity: '40 ml'),
        Ingredient(name: 'Martini Bianco', quantity: '25 ml'),
        Ingredient(name: 'Creme de Violette', quantity: '10 ml'),
        Ingredient(name: 'Lime Juice', quantity: '10 ml'),
        Ingredient(name: 'Absinthe', quantity: '1 dash'),
      ],
    ),

    Cocktail(
      name: 'Blue Movie',
      methodology: 'Shaken',
      glass: 'Hurricane',
      ice: 'Crushed Ice',
      garnish: 'Pineapple slice and Umbrella',
      ingredients: [
        Ingredient(name: 'Pineapple tea', quantity: '50 ml'),
        Ingredient(name: 'Plantation 5 y.o.', quantity: '45 ml'),
        Ingredient(name: 'Koko Kanu', quantity: '15 ml'),
        Ingredient(name: 'Lime juice', quantity: '15 ml'),
        Ingredient(name: 'Blue Curaçao', quantity: '10 ml'),
      ],
    ),

    Cocktail(
      name: 'Sling Service',
      methodology: 'Shaken',
      glass: 'Hurricane',
      ice: 'Crushed',
      garnish: '2 Cherry on a stick',
      ingredients: [
        Ingredient(name: 'Tanqueray 10', quantity: '40 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '25 ml'),
        Ingredient(name: 'Creme de cheries', quantity: '20 ml'),
        Ingredient(name: 'Mandarin Napoleon', quantity: '10 ml'),
        Ingredient(name: 'Creme de cacao Brown', quantity: '10 ml'),
        Ingredient(name: 'Prosecco', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Sex on a Plane',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Lemon Slice',
      ingredients: [
        Ingredient(name: 'Ketel One Citron', quantity: '40 ml'),
        Ingredient(name: 'Lemon juice', quantity: '25 ml'),
        Ingredient(name: 'Aperol', quantity: '20 ml'),
        Ingredient(name: 'Apricot Liquor', quantity: '20 ml'),
        Ingredient(name: 'Raspberry syrup', quantity: '15 ml'),
        Ingredient(name: 'Pimento', quantity: '5 ml'),
        Ingredient(name: 'Angostura', quantity: '3 dashes'),
        Ingredient(name: 'Mandarin & Bergamot Soda', quantity: 'Top Up'),
      ],
    ),
    Cocktail(
      name: 'Mortal Leap',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Olive oil Casamigos', quantity: '50 ml'),
        Ingredient(name: 'Lime juice', quantity: '15 ml'),
        Ingredient(name: 'Creme the cacao white', quantity: '15 ml'),
        Ingredient(name: 'Maraschino', quantity: '5 ml'),
        Ingredient(name: 'Jasmine', quantity: 'Spray'),
      ],
    ),

    Cocktail(
      name: 'Three Weels',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: '3 white grapes on stick',
      ingredients: [
        Ingredient(name: 'Watermelon Puree', quantity: '50 ml'),
        Ingredient(name: 'Pisco mosto verde', quantity: '30 ml'),
        Ingredient(name: 'Lime juice', quantity: '20 ml'),
        Ingredient(name: 'Cedrata Tassoni', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Vespa 98',
      methodology: 'Batched',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Tanqueray', quantity: '40 ml'),
        Ingredient(name: 'Tomato water', quantity: '30 ml'),
        Ingredient(name: 'Belvedere 10', quantity: '20 ml'),
        Ingredient(name: 'Cocchi americano', quantity: '5 ml'),
      ],
    ),

    Cocktail(
      name: 'Friulian Garden',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'Lavander Spring',
      ingredients: [
        Ingredient(name: 'Skerk', quantity: '50 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '20 ml'),
        Ingredient(name: 'Mar Gin', quantity: '20 ml'),
        Ingredient(name: 'Rosemary, Lavander and honey syrup', quantity: '15 ml'),
        Ingredient(name: 'Maraschino', quantity: '15 ml'),
      ],
    ),

    Cocktail(
      name: 'Scelta Sbagliata',
      methodology: 'Shaken',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'Lemon Twist',
      ingredients: [
        Ingredient(name: 'Limoncello', quantity: '20 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '25 ml'),
        Ingredient(name: 'Raspberry syrup', quantity: '20 ml'),
        Ingredient(name: 'Leopold Absinthe', quantity: '15 ml'),
        Ingredient(name: 'Prosecco', quantity: 'Top up'),
      ],
    ),

    Cocktail(
      name: 'Marsala',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Macallan 12 double casks', quantity: '30 ml'),
        Ingredient(name: 'Frangelico', quantity: '30 ml'),
        Ingredient(name: 'Pistacchio Ice Cream', quantity: '30 ml'),
      ],
    ),

    Cocktail(
      name: 'Mascarponi',
      methodology: 'Pour',
      glass: 'Rocks',
      ice: 'Ice Ball',
      garnish: 'Dehydrated Rhubarb Glued on the glass',
      ingredients: [
        Ingredient(name: 'Tanqueray 10', quantity: ''),
        Ingredient(name: 'Cocchi torino', quantity: ''),
        Ingredient(name: 'Campari', quantity: ''),
        Ingredient(name: 'Aperol', quantity: ''),
        Ingredient(name: 'Montenegro', quantity: ''),
        Ingredient(name: 'Bergamot Puree', quantity: ''),
        Ingredient(name: 'Sugar', quantity: ''),
        Ingredient(name: 'Mascarpone', quantity: ''),
      ],
    ),

    Cocktail(
      name: 'Beretta',
      methodology: 'Double Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'Star anice & 3 drops of peychaud',
      ingredients: [
        Ingredient(name: 'Appleton 12 y.o.', quantity: '40 ml'),
        Ingredient(name: 'San Bitter Rosso reduction', quantity: '30 ml'),
        Ingredient(name: 'Bergamot Puree', quantity: '20 ml'),
        Ingredient(name: 'Egg White', quantity: '20 ml'),
      ],
    ),

    Cocktail(
      name: 'Mezzo & Mezzo',
      methodology: 'Shaken',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'Discarded Grapefruit & Grapefruit coin',
      ingredients: [
        Ingredient(name: 'Lost Explorer Espadin', quantity: '20 ml'),
        Ingredient(name: 'Sanbitter Rosso', quantity: '30 ml'),
        Ingredient(name: 'Lime Juice', quantity: '15 ml'),
        Ingredient(name: 'Ancho Reyes Verde', quantity: '10 ml'),
        Ingredient(name: 'Campari', quantity: '5 ml'),
      ],
    ),

    Cocktail(
      name: 'Al-Madinah',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Grapefruit twist',
      ingredients: [
        Ingredient(name: 'Palmarae', quantity: '30 ml'),
        Ingredient(name: 'Professore rosso', quantity: '30 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '20 ml'),
        Ingredient(name: 'Crodino', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'May Queen',
      methodology: 'Stirred',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'Rose Petal',
      ingredients: [
        Ingredient(name: 'Seventy One Gin', quantity: '30 ml'),
        Ingredient(name: 'Palo Cortado', quantity: '15 ml'),
        Ingredient(name: 'Rosé petal syrup', quantity: '15 ml'),
        Ingredient(name: 'Lemon Juice', quantity: '10 ml'),
      ],
    ),
  Cocktail(
      name: 'Aguacaliente',
      methodology: 'Pour',
      glass: 'Rocks',
      ice: 'Block',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Casa Dragones Blanco', quantity: '40 ml'),
        Ingredient(name: 'Coconut Milk', quantity: '30 ml'),
        Ingredient(name: 'Cointreau', quantity: '20 ml'),
        Ingredient(name: 'Lime Juice', quantity: '20 ml'),
        Ingredient(name: 'Creme de banane', quantity: '15 ml'),
      ],
    ),

    Cocktail(
      name: 'Los Mariachis',
      methodology: 'Shaken',
      glass: 'Rock',
      ice: 'Block',
      garnish: 'Ginger Slice',
      ingredients: [
        Ingredient(name: 'Casamigos Silver', quantity: '40 ml'),
        Ingredient(name: 'Lime Juice', quantity: '20 ml'),
        Ingredient(name: 'Falernum', quantity: '15 ml'),
        Ingredient(name: 'Sugar Syrup', quantity: '5 ml'),
        Ingredient(name: 'Pimento Dram', quantity: '5 ml'),
      ],
    ),

    Cocktail(
      name: 'No Pasa Nada',
      methodology: 'Shaken',
      glass: 'Coupe',
      ice: 'Up',
      garnish: 'Coconut Salt rim',
      ingredients: [
        Ingredient(name: 'Dill infused mezcal', quantity: '50 ml'),
        Ingredient(name: 'Lime juice', quantity: '25 ml'),
        Ingredient(name: 'Agave water', quantity: '15 ml'),
        Ingredient(name: 'Koko Kanu', quantity: '15 ml'),
        Ingredient(name: 'Palo Cortado', quantity: '5 ml'),
      ],
    ),

    Cocktail(
      name: 'Omacatl',
      methodology: 'Pour/Shaken',
      glass: 'Highball',
      ice: 'Cubed Ice',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Arette blanco', quantity: '45 ml'),
        Ingredient(name: 'Tamarind syrup', quantity: '30 ml'),
        Ingredient(name: 'Ancho Reyes Verde', quantity: '7.5 ml'),
        Ingredient(name: 'Ojo De Dios Caffè', quantity: '2.5 ml'),
        Ingredient(name: 'Slim Tonic', quantity: 'Top up'),
      ],
    ),

    Cocktail(
      name: 'Calavera',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: '2 Cherry on a stick',
      ingredients: [
        Ingredient(name: 'Casamigos Blanco', quantity: '30 ml'),
        Ingredient(name: 'Sour Cherry liquer', quantity: '30 ml'),
        Ingredient(name: 'Lime Juice', quantity: '30 ml'),
      ],
    ),

    Cocktail(
      name: 'Pacto de Sangre',
      methodology: 'Shaken',
      glass: 'Highball',
      ice: 'Cubed',
      garnish: 'Hibiscus Leaves',
      ingredients: [
        Ingredient(name: 'Mijenta Blanco', quantity: '50 ml'),
        Ingredient(name: 'Cumin Syrup', quantity: '30 ml'),
        Ingredient(name: 'Lime juice', quantity: '20 ml'),
        Ingredient(name: 'Salt Solution', quantity: '3 dashes'),
        Ingredient(name: 'Soda', quantity: 'Top Up'),
      ],
    ),

    Cocktail(
      name: 'Old Coahuila',
      methodology: 'Stirred',
      glass: 'Rock',
      ice: 'Block',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Nachos infused Casamigos blanco', quantity: '50 ml'),
        Ingredient(name: 'Sugar Syrup', quantity: '5 ml'),
        Ingredient(name: 'Salt solution', quantity: '3 dashes'),
      ],
    ),

    Cocktail(
      name: 'Cocalita',
      methodology: 'Shaken',
      glass: 'Nick & Nora',
      ice: 'Up',
      garnish: 'No garnish',
      ingredients: [
        Ingredient(name: 'Tapatio repo', quantity: '50 ml'),
        Ingredient(name: 'Coconut cream', quantity: '25 ml'),
        Ingredient(name: 'Lime Juice', quantity: '25 ml'),
        Ingredient(name: 'Scotch Bonnet Chili', quantity: '5 ml'),
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
