import 'package:flutter/foundation.dart';
import '../models/checklist.dart';
import '../services/firestore_service.dart';

final List<String> defaultTopTasks = [
  'Remove cling film and condoms',
  'Request missing wines',
  'Check the bar',
  'Request missing bottles',
  'Fruit (oranges / limes / lemons / grapefruit)',
  'To cut',
  'For peeling',
  'Check soft drinks',
  'Check beers',
];

final Map<String, List<String>> defaultSections = {
  'Syrups:': [
    'Shrub',
    'Lime cordial',
    'Raspberry',
    'Olive brine',
    'Agave water',
    'Pineapple tea',
    'Granadine',
    'Honey ginger',
    'Orange cordial',
    'Honey chili and sage',
    'Honey water',
    'Passion fruit puree',
    'Double cream',
    'Egg white',
    'Peach & elderflower',
    'Coconut cream',
  ],
  'Juices:': [
    'Orange juice',
    'Grapefruit juice',
    'Cranberry',
    'Pineapple',
    'Apple',
    'Lemon',
    'Lime',
    'Coffee',
  ],
  'Garnish:': [
    'Mint leaves',
    'Mint sprigs',
    'Salt',
    'Tajin',
    'Sugar',
    'Maraschino cherry',
    'Martini olives',
    'Cucumber',
    'Dry pineapple',
    'Peels (orange, lemon, grapefruit, lime)',
  ],
  'Bitters:': [
    'Angostura',
    'Orange Bitter',
    'Absinthe',
    'Peychaud bitter',
    'Boker’s bitter',
    'Tabasco',
  ],
  'Tools:': [
    'Shakers',
    'Mixing glass',
    'Jiggers(20/40, 25/50, 30/60, preciso)',
    'Bamboo skewers',
    'Napkins',
    'Ice pick',
    'Chopping board',
    'Fine strainers',
    'Strainers',
    'Bar spoons',
    'Ice block tongs',
    'Tongs',
    'Muddler',
    'Knives',
    'Pdq rolls small',
    'Peelers',
  ],
  'Soft drinks': [
    'Soda',
    'Tonic',
    'Ginger Beer',
    'Ginger Ale',
    'Lemonade',
    'Slim Tonic',
    'Coca-Cola',
    'Diet Coke',
    'Mandarin & Bergamot Soda',
  ],
};

Future<void> insertInitialChecklistsForVenues(List<String> venues) async {
  final checklist = ChecklistData(
    topTasks: List<String>.from(defaultTopTasks),
    sections: Map<String, List<String>>.from(defaultSections),
    checked: <String>{},
  );

  for (final venue in venues) {
    try {
      await FirestoreService.saveChecklist(venue, checklist);
    } catch (e) {
      debugPrint('Error seeding checklist for $venue: $e');
    }
  }
}

