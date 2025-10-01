import 'package:flutter/material.dart';

import '../models/menu.dart';
// removed unused cocktail import
import '../pages/menucocktaillistpage.dart';
import '../services/firestore_service.dart';
class Menus extends StatefulWidget {
  const Menus({super.key});

  @override
  State<Menus> createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  String _activeFilter = 'All';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder<List<Menu>>(
        stream: FirestoreService.watchMenus(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final menus = snapshot.data!;
          
          // Organize menus by venue type
          final signaturesMenus = menus.where((menu) => 
            ['Terrace', 'Tavern', 'Attic', 'Sushi', 'Circle & Parlour', 'Virgin & Low ABV'].contains(menu.title)).toList();
          final classicMenus = menus.where((menu) => 
            ["A","B","C","D","E","F","G","H","I","J","K","M","N","O","P","R","S","T","V","W",].contains(menu.title)).toList();
          final specialMenus = menus.where((menu) => 
            ['Negroni Menu', 'Weekly Selection'].contains(menu.title)).toList();

          List<Widget> buildRows() {
            switch (_activeFilter) {
              case 'Signatures':
                return [_buildMenuSection('Signature Cocktails', signaturesMenus)];
              case 'Classic':
                return [_buildMenuSection('Classic Cocktails', classicMenus)];
              case 'Special':
                return [_buildMenuSection('Special Menues', specialMenus)];
              case 'All':
              default:
                return [
                  _buildMenuSection('Signature Cocktails', signaturesMenus),
                  _buildMenuSection('Classic Cocktails', classicMenus),
                  _buildMenuSection('Special Menues', specialMenus),
                ];
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      _filterButton('All'),
                      _filterButton('Signatures'),
                      _filterButton('Classic'),
                      _filterButton('Special'),
                    ],
                  ),
                ),
                ...buildRows(),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
      'Menus',
      style: TextStyle(
        color: Colors.white,
        fontSize: 26, 
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: false,
    backgroundColor: Colors.deepPurpleAccent,
    );
  }

  Widget _filterButton(String label) {
    final bool selected = _activeFilter == label;
    return ElevatedButton(
      onPressed: () => setState(() => _activeFilter = label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: BorderSide(color: Colors.white.withOpacity(selected ? 0.0 : 0.0))),
        elevation: selected ? 2 : 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildMenuSection(String title, List<Menu> menus) {
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
                        child: StreamBuilder<List<Menu>>(
                          stream: FirestoreService.watchMenus(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final allMenus = snapshot.data!;
                            final availableMenus = allMenus.where((menu) => !menus.contains(menu)).toList();
                            if (availableMenus.isEmpty) {
                              return const Center(child: Text('No available menus to add'));
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
                                    setState(() { menus.add(menu); });
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menus.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final menu = menus[index];
              return _buildMenuCard(menu);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(Menu menu) {
    // Get the first cocktail from the menu to use its name as a preview
    final previewCocktail = menu.cocktailsNames.isNotEmpty ? menu.cocktailsNames.first : '';

    return Container(
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
                height: 84,
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

  

  
