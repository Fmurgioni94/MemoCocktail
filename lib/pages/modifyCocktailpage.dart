import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import 'addCocktailForm.dart';

class ModifyCocktailPage extends StatefulWidget {  // Changed to StatefulWidget
  const ModifyCocktailPage({super.key});

  @override
  State<ModifyCocktailPage> createState() => _ModifyCocktailPageState();
}

class _ModifyCocktailPageState extends State<ModifyCocktailPage> {
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
          'Modify Cocktail',
          style: TextStyle(
            color: Colors.white,
          ),
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
                hintText: 'Search cocktails...',
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
              valueListenable: Hive.box<Cocktail>('cocktails').listenable(),
              builder: (context, Box<Cocktail> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      'No cocktails available to modify',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final filteredCocktails = box.values.where((cocktail) {
                  return cocktail.name.toLowerCase().contains(_searchQuery) ||
                         cocktail.methodology.toLowerCase().contains(_searchQuery) ||
                         cocktail.glass.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredCocktails.isEmpty) {
                  return const Center(
                    child: Text(
                      'No cocktails found matching your search',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredCocktails.length,
                  itemBuilder: (context, index) {
                    final cocktail = filteredCocktails[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(
                          cocktail.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Methodology: ${cocktail.methodology}'),
                            Text('Glass: ${cocktail.glass}'),
                            Text('Ingredients: ${cocktail.ingredients.length}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCocktailForm(cocktail: cocktail),
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
                                    title: const Text('Delete Cocktail'),
                                    content: Text('Are you sure you want to delete "${cocktail.name}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          box.delete(cocktail.name);
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