import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import '../services/firestore_service.dart';

class AddMenuForm extends StatefulWidget {
  final Menu? menu; // If null, we're adding a new menu

  const AddMenuForm({super.key, this.menu});

  @override
  State<AddMenuForm> createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _selectedCocktails = [];

  @override
  void initState() {
    super.initState();
    if (widget.menu != null) {
      _titleController.text = widget.menu!.title;
      _selectedCocktails.addAll(widget.menu!.cocktailsNames);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _saveMenu() async {
    if (_formKey.currentState!.validate() && _selectedCocktails.isNotEmpty) {
      final menu = Menu(
        title: _titleController.text,
        cocktailsNames: _selectedCocktails,
      );

      await FirestoreService.upsertMenu(menu);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menu == null ? 'Add New Menu' : 'Edit Menu',
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Menu Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Selected Cocktails',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Cocktail>>(
                stream: FirestoreService.watchCocktails(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredCocktails = snapshot.data!
                      .where((cocktail) => cocktail.name.toLowerCase().contains(_searchQuery))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredCocktails.length,
                    itemBuilder: (context, index) {
                      final cocktail = filteredCocktails[index];
                      final isSelected = _selectedCocktails.contains(cocktail.name);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          title: Text(cocktail.name),
                          subtitle: Text('${cocktail.ingredients.length} ingredients'),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCocktails.add(cocktail.name);
                              } else {
                                _selectedCocktails.remove(cocktail.name);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveMenu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(widget.menu == null ? 'Create Menu' : 'Save Changes'),
              ),
            ),
            // ... existing imports and code ...

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Cocktails',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCocktails.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear Selection'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}