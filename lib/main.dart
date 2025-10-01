import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/initial_cocktails.dart';
import 'data/initial_menus.dart';
import 'data/initial_checklists.dart';
import 'firebase_options.dart';
import 'services/firestore_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required for async init
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

  // Seed initial data in background to avoid blocking first frame
  _seedInitialData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

Future<void> _seedInitialData() async {
  try {
    final venues = [
      'Vaults',
      'Circle',
      'Parlour',
      'Drowing room',
      'Pantry',
      'Brasserie',
      'Attic',
      'Tavern',
      'Terrace',
    ];
    // await FirestoreService.upsertVenues(venues);
    // await insertInitialChecklistsForVenues(venues);
    // await insertInitialCocktails();
    // await insertInitialMenus();
  } catch (e) {
    // Log seeding errors for diagnosis
    debugPrint('Seeding failed: $e');
  }
}