import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import 'addNewMenu.dart';

class ModifyMenu extends StatefulWidget {
  const ModifyMenu({super.key});

  @override
  State<ModifyMenu> createState() => _ModifyMenuState();
}

class _ModifyMenuState extends State<ModifyMenu> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modify Menu',
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menus...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Menu>('menus').listenable(),
              builder: (context, Box<Menu> menuBox, _) {
                if (menuBox.isEmpty) {
                  return const Center(
                    child: Text(
                      'No menus available to modify',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final filteredMenus = menuBox.values.where((menu) {
                  return menu.title.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredMenus.isEmpty) {
                  return const Center(
                    child: Text(
                      'No menus found matching your search',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredMenus.length,
                  itemBuilder: (context, index) {
                    final menu = filteredMenus[index];
                    final cocktailBox = Hive.box<Cocktail>('cocktails');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              menu.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${menu.cocktailsNames.length} cocktails'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMenuForm(menu: menu),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Menu'),
                                        content: Text('Are you sure you want to delete "${menu.title}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              menuBox.delete(menu.title);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'),
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cocktails in this menu:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...menu.cocktailsNames.map((cocktailName) {
                                  final cocktail = cocktailBox.get(cocktailName);
                                  if (cocktail == null) return const SizedBox.shrink();
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text('• ${cocktail.name}'),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}