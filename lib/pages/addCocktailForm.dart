import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import '../models/ingredient.dart';

class AddCocktailForm extends StatefulWidget {
  final Cocktail? cocktail; // If null, we're adding a new cocktail

  const AddCocktailForm({super.key, this.cocktail});

  @override
  State<AddCocktailForm> createState() => _AddCocktailFormState();
}

class _AddCocktailFormState extends State<AddCocktailForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _methodologyController = TextEditingController();
  final _glassController = TextEditingController();
  final _iceController = TextEditingController();
  final _garnishController = TextEditingController();
  final _levelTagController = TextEditingController();
  final _notesController = TextEditingController();
  
  final List<Ingredient> _ingredients = [];
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cocktail != null) {
      // If editing existing cocktail, populate fields
      _nameController.text = widget.cocktail!.name;
      _methodologyController.text = widget.cocktail!.methodology;
      _glassController.text = widget.cocktail!.glass;
      _iceController.text = widget.cocktail!.ice;
      _garnishController.text = widget.cocktail!.garnish;
      _levelTagController.text = widget.cocktail!.levelTag;
      _notesController.text = widget.cocktail!.notes;
      _ingredients.addAll(widget.cocktail!.ingredients);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _methodologyController.dispose();
    _glassController.dispose();
    _iceController.dispose();
    _garnishController.dispose();
    _levelTagController.dispose();
    _notesController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    if (_ingredientNameController.text.isNotEmpty && 
        _ingredientQuantityController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(Ingredient(
          name: _ingredientNameController.text,
          quantity: _ingredientQuantityController.text,
        ));
        _ingredientNameController.clear();
        _ingredientQuantityController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _saveCocktail() {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
      final cocktail = Cocktail(
        name: _nameController.text,
        methodology: _methodologyController.text,
        glass: _glassController.text,
        ice: _iceController.text,
        garnish: _garnishController.text,
        ingredients: _ingredients,
        levelTag: _levelTagController.text,
        notes: _notesController.text,
      );

      final box = Hive.box<Cocktail>('cocktails');
      if (widget.cocktail != null) {
        // Update existing cocktail
        box.put(widget.cocktail!.name, cocktail);
      } else {
        // Add new cocktail
        box.put(cocktail.name, cocktail);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cocktail == null ? 'Add Cocktail' : 'Edit Cocktail',
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Cocktail Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: _methodologyController,
              decoration: const InputDecoration(labelText: 'Methodology'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter methodology' : null,
            ),
            TextFormField(
              controller: _glassController,
              decoration: const InputDecoration(labelText: 'Glass'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter glass type' : null,
            ),
            TextFormField(
              controller: _iceController,
              decoration: const InputDecoration(labelText: 'Ice'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter ice type' : null,
            ),
            TextFormField(
              controller: _garnishController,
              decoration: const InputDecoration(labelText: 'Garnish'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter garnish' : null,
            ),
            TextFormField(
              controller: _levelTagController,
              decoration: const InputDecoration(labelText: 'Level Tag'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter level tag' : null,
            ),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ingredientNameController,
                    decoration: const InputDecoration(labelText: 'Ingredient Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _ingredientQuantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addIngredient,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._ingredients.asMap().entries.map((entry) {
              return ListTile(
                title: Text('${entry.value.name} - ${entry.value.quantity}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeIngredient(entry.key),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCocktail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.cocktail == null ? 'Add Cocktail' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}