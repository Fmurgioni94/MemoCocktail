import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import '../pages/menucocktaillistpage.dart';
class Menus extends StatefulWidget {
  const Menus({super.key});

  @override
  State<Menus> createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  @override
  Widget build(BuildContext context) {
    final menuBox = Hive.box<Menu>('menus');
    final cocktailBox = Hive.box<Cocktail>('cocktails');

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: menuBox.listenable(),
        builder: (context, Box<Menu> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No menus available.'));
          }

          final menus = box.values.toList();
          
          // Organize menus by venue type
          final signaturesMenus = menus.where((menu) => 
            ['Terrace', 'Tavern', 'Attic', 'Sushi', 'Circle & Parlour', 'Virgin & Low ABV'].contains(menu.title)).toList();
          
          final classicMenus = menus.where((menu) => 
            ["A","B","C","D","E","F","G","H","I","J","K","M","N","O","P","R","S","T","V","W",].contains(menu.title)).toList();
          
          final specialMenus = menus.where((menu) => 
            ['Negroni Menu', 'Weekly Selection'].contains(menu.title)).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuSection('Signature Cocktails', signaturesMenus, cocktailBox),
                _buildMenuSection('Classic Cocktails', classicMenus, cocktailBox),
                _buildMenuSection('Special Menues', specialMenus, cocktailBox),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Menu> menus, Box<Cocktail> cocktailBox) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.deepPurpleAccent,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Add to $title'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ValueListenableBuilder(
                          valueListenable: Hive.box<Menu>('menus').listenable(),
                          builder: (context, Box<Menu> box, _) {
                            final allMenus = box.values.toList();
                            // Filter out menus that are already in this section
                            final availableMenus = allMenus.where(
                              (menu) => !menus.contains(menu)
                            ).toList();

                            if (availableMenus.isEmpty) {
                              return const Center(
                                child: Text('No available menus to add'),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: availableMenus.length,
                              itemBuilder: (context, index) {
                                final menu = availableMenus[index];
                                return ListTile(
                                  title: Text(menu.title),
                                  subtitle: Text('${menu.cocktailsNames.length} cocktails'),
                                  onTap: () {
                                    // Add the menu to this section
                                    setState(() {
                                      menus.add(menu);
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              return _buildMenuCard(menu, cocktailBox);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(Menu menu, Box<Cocktail> cocktailBox) {
    // Get the first cocktail from the menu to use its name as a preview
    final previewCocktail = menu.cocktailsNames.isNotEmpty ? menu.cocktailsNames.first : '';

    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MenuCocktailListPage(menu: menu),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getMenuIcon(menu.title),
                        size: 32,
                        color: Colors.deepPurpleAccent,
                      ),
                      if (previewCocktail.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            previewCocktail,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.deepPurpleAccent,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${menu.cocktailsNames.length} cocktails',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMenuIcon(String menuTitle) {
    switch (menuTitle) {
      case 'Sushi':
        return Icons.restaurant;
      case 'Tavern':
        return Icons.local_bar;
      case 'Terrace':
        return Icons.deck;
      case 'Attic':
        return Icons.attractions;
      case 'Pantry':
        return Icons.kitchen;
      case 'Al-Madinah':
        return Icons.mosque;
      default:
        return Icons.menu_book;
    }
  }
}

  

  
