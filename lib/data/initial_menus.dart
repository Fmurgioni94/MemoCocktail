import '../models/menu.dart';
import '../services/hive_service.dart';

Future<void> insertInitialMenus() async {
  final menus = <Menu>[
    Menu(
      title: "Salamanca",
      cocktailsNames: [
        "Salamanca (cocktail)",
        "Virgin & Low ABV",
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
      title: "Circol & Parlour",
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
        "French Canadian",
        "Teano",
        "Alabaster Ale",
        "Lovely Pear",
        "Apertas",
        "Marcello",
        "Zaza",
      ],
    ),
    Menu(
      title: "Tavern",
      cocktailsNames: [
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
      title: "Al-Madinah",
      cocktailsNames: ["May Queen"],
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
      title: "Pantry",
      cocktailsNames: [
        "La Cura",
        "Albariza",
        "Carthusian",
        "Persistence",
        "Carte Blanche",
        "Endeavour",
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
