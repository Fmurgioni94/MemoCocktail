import '../models/menu.dart';
import '../services/hive_service.dart';

Future<void> insertInitialMenus() async {
  final menus = <Menu>[
    Menu(
      title: "Virgin & Low ABV",
      cocktailsNames: [
        "Mamba",
        "Virgin Pennicciline",
        "Forest For The Trees",
        "Roachester",
        "The EBP",
        "Harabell Spritz",
        "Bordoni",
      ],
    ),
    Menu(
      title: "Sushi",
      cocktailsNames: [
        "Ichijiku",
        "Umeomaru",
        "Hishicari",
        "Hato",
        "Nisshoki",
        "Katana 75",
        "Hokusai Special",
        "Shibuya",
        "Chanoyu",
      ],
    ),
    Menu(
      title: "Circle & Parlour",
      cocktailsNames: [
        "To Kill a Sunrise",
        "Harvey Doorbanger",
        "Wrong Island Ice Tea",
        "Stepfather",
        "Daisy Duke",
        "Blue Movie",
        "Sling Service",
        "Sex on a Plane",
      ],
    ),
    Menu(
      title: "Attic",
      cocktailsNames: [
        'Nico',
        'L\'Italien',
        'Bandolero',
        'The Duke Bellini',
        'House Punch',
        'Teano',
        'Apertas',
        'Cicchetto',
      ],
    ),
    Menu(
      title: "Tavern",
      cocktailsNames: [
        'Al-Madinah',
        "Mortal Leap",
        "Three Weels",
        "Vespa 98",
        "Friulian Garden",
        "Scelta Sbagliata",
        "Marsala",
        "Mascarponi",
        "Beretta",
        "Mezzo & Mezzo",
      ],
    ),
    Menu(
      title: "Terrace",
      cocktailsNames: [
        "Aguacaliente",
        "Los Mariachis",
        "No Pasa Nada",
        "Omacatl",
        "Calavera",
        "Pacto de Sangre",
        "Old Coahuila",
        "Cocalita",
      ],
    ),
    Menu(
      title: "Weekly Selection",
      cocktailsNames: [
        "Adonis",
        "Brooklyn",
        "Planter’s Punch",
        "Singapore Sling",
        "Toreador"
      ],
    ),
    Menu(
      title: "Negroni Menu",
      cocktailsNames: [
        "Vintage Negroni",
        "Vintage Americano",
        "The Camillo",
        "The Pascal",
        "The Fosco"
      ],
    ),
  Menu(
    title: "A",
    cocktailsNames: [
      "Absinthe Frappé",
      "Adonis",
      "Airmail",
      "Americano",
      "Aperol Spritz",
      "Army & Navy",
      "Aviation",
    ],
  ),
  Menu(
    title: "B",
    cocktailsNames: [
      "Bamboo",
      "Bee’s Knees",
      "Bellini",
      "Black / White Russian",
      "Bobby Burns",
      "Boulevardier",
      "Brandy Alexander",
      "Brandy Crusta",
      "Bramble",
      "Buck’s Fizz",
    ],
  ),
  Menu(
    title: "C",
    cocktailsNames: [
      "Caipi",
      "Capirinha",
      "Casino",
      "Champagne Cocktail",
      "Charlie Chaplin",
      "Clover Club",
      "Coffee Cocktail",
      "Corpse Reviver #2",
      "Cosmopolitan",
    ],
  ),
  Menu(
    title: "D",
    cocktailsNames: [
      "Daiquiri",
      "Dark ’N’ Stormy",
      "Dirty Martini",
    ],
  ),
  Menu(
    title: "E",
    cocktailsNames: [
      "El Diablo",
      "El Presidente",
      "Embassy",
      "Espresso Martini",
    ],
  ),
  Menu(
    title: "F",
    cocktailsNames: [
      "Fish House Punch",
      "Floradora",
      "French Martini",
    ],
  ),
  Menu(
    title: "G",
    cocktailsNames: [
      "Gibson",
      "Gimlet",
      "Gin Rickey",
      "Godfather",
      "Golden Cadillac",
      "Grasshopper",
    ],
  ),
  Menu(
    title: "H",
    cocktailsNames: [
      "Harvard",
      "Hanky Panky",
      "Hemingway Special",
      "Hot Toddy",
      "Hurricane",
    ],
  ),
  Menu(
    title: "I",
    cocktailsNames: [
      "Irish Coffee",
    ],
  ),
  Menu(
    title: "J",
    cocktailsNames: [
      "Jack Rose",
      "Jungle Bird",
    ],
  ),
  Menu(
    title: "K",
    cocktailsNames: [
      "Kyr / Kyr Royale",
    ],
  ),
  Menu(
    title: "M",
    cocktailsNames: [
      "Mai Tai",
      "Manhattan Perfect",
      "Manhattan Sweet",
      "Margarita",
      "Martinez",
      "Martini Dry",
      "Martini Very Dry",
      "Martini Wet",
      "Mary Pickford",
      "Milano Torino",
      "Mimosa",
      "Mint Julep",
      "Mojito",
      "Morning Glory Fizz",
      "Moscow Mule",
    ],
  ),
  Menu(
    title: "N",
    cocktailsNames: [
      "Negroni",
      "New York Sour",
    ],
  ),
  Menu(
    title: "O",
    cocktailsNames: [
      "Old Fashioned",
    ],
  ),
  Menu(
    title: "P",
    cocktailsNames: [
      "Paloma",
      "Passion Martini",
      "Pegu Club",
      "Pennicillin",
      "Perfect Lady",
      "Pina Colada",
      "Pink Gin",
      "Pisco Sour",
      "Planter’s Punch",
    ],
  ),
  Menu(
    title: "R",
    cocktailsNames: [
      "Ramos Gin Fizz",
      "Rattlesnake",
      "Rob Roy",
      "Rusty Nail",
    ],
  ),
  Menu(
    title: "S",
    cocktailsNames: [
      "Saratoga",
      "Sazerac",
      "Satan’s Whiskers",
      "Sherry Cobbler",
      "Sidecar",
      "Singapore Sling",
      "Sours (Any)",
      "Stinger",
    ],
  ),
  Menu(
    title: "T",
    cocktailsNames: [
      "The Last Word",
      "Toreador",
      "Toronto",
      "Twentieth Century",
      "Twinkle",
      "Tuxedo",
    ],
  ),
  Menu(
    title: "V",
    cocktailsNames: [
      "Vieux Carré",
    ],
  ),
  Menu(
    title: "W",
    cocktailsNames: [
      "Whisky Mac",
      "White Lady",
      "White Negroni",
    ],
  ),
];

  final box = HiveService.menuBox;

  for (var menu in menus) {
    if (!box.containsKey(menu.title)) {
      await box.put(menu.title, menu);
    }
  }
}
