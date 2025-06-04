import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import 'package:MemoCocktail/pages/cocktaildetailpage.dart';

class Homepagecontent extends StatefulWidget {
  const Homepagecontent({super.key});

  @override
  State<Homepagecontent> createState() => _HomepagecontentState();
}

class _HomepagecontentState extends State<Homepagecontent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cocktailBox = Hive.box<Cocktail>('cocktails');
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cocktails...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: cocktailBox.listenable(),
              builder: (context, Box<Cocktail> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No cocktails available.'));
                }

                final cocktails = box.values
                    .where((cocktail) => cocktail.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                if (cocktails.isEmpty) {
                  return const Center(child: Text('No cocktails found.'));
                }

                return ListView.builder(
                  itemCount: cocktails.length,
                  itemBuilder: (context, index) {
                    final cocktail = cocktails[index];
                    return ListTile(
                      title: Text(cocktail.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CocktailDetailPage(cocktail: cocktail),
                          ),
                        );
                      },
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