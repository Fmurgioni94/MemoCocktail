import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/homepage.dart';
import 'services/hive_service.dart';
import 'data/initial_cocktails.dart';
import 'data/initial_menus.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required for async init
  await HiveService.init(); // ✅ Initialize Hive
  await insertInitialCocktails(); // ✅ Insert initial cocktails
  await insertInitialMenus(); // ✅ Insert initial menus
  runApp(const MyApp());
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