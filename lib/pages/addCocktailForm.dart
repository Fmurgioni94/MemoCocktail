import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../models/ingredient.dart';
import '../services/firestore_service.dart';

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
  bool _isSaving = false;
  final List<String> _methodologyOptions = const ['Stir', 'Shake', 'Double shake', 'Throw', 'Build'];
  String? _selectedMethodology;
  final List<String> _glassOptions = const ['Highball', 'Rock', 'Coupe', 'Nick & Nora', 'Hurricane', 'Wine glass', 'Flute'];
  String? _selectedGlass;
  final List<String> _iceOptions = const ['Block', 'Cube', 'Crush', 'Up'];
  String? _selectedIce;
  final List<String> _levelTagOptions = const ['Bartender', 'Senior Bartender', 'Signature'];
  String? _selectedLevelTag;
  
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
      _selectedMethodology = _normalizeMethodology(widget.cocktail!.methodology);
      _glassController.text = widget.cocktail!.glass;
      _selectedGlass = _normalizeGlass(widget.cocktail!.glass);
      _iceController.text = widget.cocktail!.ice;
      _selectedIce = _normalizeIce(widget.cocktail!.ice);
      _garnishController.text = widget.cocktail!.garnish;
      _levelTagController.text = widget.cocktail!.levelTag;
      _selectedLevelTag = _normalizeLevelTag(widget.cocktail!.levelTag);
      _notesController.text = widget.cocktail!.notes;
      _ingredients.addAll(widget.cocktail!.ingredients);
    }
  }

  String? _normalizeMethodology(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.contains('double')) return 'Double shake';
    if (s.startsWith('stir')) return 'Stir';
    if (s.startsWith('shake')) return 'Shake';
    if (s.startsWith('throw')) return 'Throw';
    if (s.startsWith('build')) return 'Build';
    return _methodologyOptions.contains(raw) ? raw : null;
  }

  String? _normalizeGlass(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.startsWith('highball')) return 'Highball';
    if (s == 'rock' || s == 'rocks' || s == 'rocks glass' || s == 'rock glass') return 'Rock';
    if (s.startsWith('coupe')) return 'Coupe';
    if (s.contains('nick') && s.contains('nora')) return 'Nick & Nora';
    if (s.startsWith('hurricane')) return 'Hurricane';
    if (s.contains('wine')) return 'Wine glass';
    if (s.startsWith('flute')) return 'Flute';
    return _glassOptions.contains(raw) ? raw : null;
  }

  String? _normalizeIce(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.startsWith('block')) return 'Block';
    if (s.startsWith('cube') || s == 'cubed') return 'Cube';
    if (s.startsWith('crush') || s == 'crushed') return 'Crush';
    if (s == 'up' || s == 'no ice') return 'Up';
    return _iceOptions.contains(raw) ? raw : null;
  }

  String? _normalizeLevelTag(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.startsWith('senior')) return 'Senior Bartender';
    if (s.startsWith('signature')) return 'Signature';
    if (s.startsWith('bartender')) return 'Bartender';
    return _levelTagOptions.contains(raw) ? raw : null;
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

  Future<void> _saveCocktail() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one ingredient'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    {
      FocusScope.of(context).unfocus();
      setState(() => _isSaving = true);
      final name = _nameController.text.trim();
      final cocktail = Cocktail(
        name: name,
        methodology: (_selectedMethodology ?? _methodologyController.text).trim(),
        glass: (_selectedGlass ?? _glassController.text).trim(),
        ice: (_selectedIce ?? _iceController.text).trim(),
        garnish: _garnishController.text.trim(),
        ingredients: _ingredients,
        levelTag: (_selectedLevelTag ?? _levelTagController.text).trim(),
        notes: _notesController.text.trim(),
      );
      try {
        // Check for duplicates and ask to overwrite
        final existing = await FirestoreService.getCocktailByName(cocktail.name);
        if (existing != null && widget.cocktail == null) {
          final overwrite = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cocktail already exists'),
              content: Text('Replace the existing "${cocktail.name}"?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Overwrite')),
              ],
            ),
          );
          if (overwrite != true) {
            setState(() => _isSaving = false);
            return;
          }
        }
        // If editing and the name changed, confirm rename and delete old doc after saving new
        if (widget.cocktail != null && widget.cocktail!.name.trim() != name) {
          final confirmRename = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Rename cocktail?'),
              content: Text('Save as "$name" and remove "${widget.cocktail!.name}"?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Rename')),
              ],
            ),
          );
          if (confirmRename != true) {
            setState(() => _isSaving = false);
            return;
          }
          await FirestoreService.upsertCocktail(cocktail);
          await FirestoreService.deleteCocktailByName(widget.cocktail!.name);
        } else {
          await FirestoreService.upsertCocktail(cocktail);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cocktail saved'), behavior: SnackBarBehavior.floating),
        );
        Navigator.pop(context);
      } on Exception catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), behavior: SnackBarBehavior.floating),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
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
            _SectionCard(children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Cocktail name',
                  prefixIcon: Icon(Icons.local_bar),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedMethodology,
                items: _methodologyOptions
                    .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
                    .toList(),
                decoration: const InputDecoration(
                  hintText: 'Methodology',
                  prefixIcon: Icon(Icons.science_outlined),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onChanged: (v) => setState(() => _selectedMethodology = v),
                validator: (value) => (value == null || value.isEmpty) ? 'Please select methodology' : null,
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedGlass,
                  items: _glassOptions
                      .map((g) => DropdownMenuItem<String>(value: g, child: Text(g)))
                      .toList(),
                  decoration: const InputDecoration(
                    hintText: 'Glass',
                    prefixIcon: Icon(Icons.wine_bar),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  onChanged: (v) => setState(() => _selectedGlass = v),
                  validator: (value) => (value == null || value.isEmpty) ? 'Select glass' : null,
                )),
                const SizedBox(width: 12),
                Expanded(child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedIce,
                  items: _iceOptions
                      .map((i) => DropdownMenuItem<String>(value: i, child: Text(i)))
                      .toList(),
                  decoration: const InputDecoration(
                    hintText: 'Ice',
                    prefixIcon: Icon(Icons.ac_unit_outlined),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  onChanged: (v) => setState(() => _selectedIce = v),
                  validator: (value) => (value == null || value.isEmpty) ? 'Select ice' : null,
                )),
              ]),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              TextFormField(
                controller: _garnishController,
                decoration: const InputDecoration(
                  hintText: 'Garnish',
                  prefixIcon: Icon(Icons.spa_outlined),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter garnish' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedLevelTag,
                items: _levelTagOptions
                    .map((l) => DropdownMenuItem<String>(value: l, child: Text(l)))
                    .toList(),
                decoration: const InputDecoration(
                  hintText: 'Level',
                  prefixIcon: Icon(Icons.verified_outlined),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onChanged: (v) => setState(() => _selectedLevelTag = v),
                validator: (value) => (value == null || value.isEmpty) ? 'Please select level' : null,
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 0),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.sticky_note_2_outlined),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                maxLines: 3,
              ),
            ]),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Ingredients',
              children: [
                Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: _ingredientNameController,
                      decoration: const InputDecoration(
                        hintText: 'Ingredient',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (_) => _addIngredient(),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: TextFormField(
                      controller: _ingredientQuantityController,
                      decoration: const InputDecoration(
                        hintText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (_) => _addIngredient(),
                    )),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addIngredient,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._ingredients.asMap().entries.map((entry) {
                  return Dismissible(
                    key: ValueKey('${entry.key}-${entry.value.name}-${entry.value.quantity}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeIngredient(entry.key),
                    child: ListTile(
                      title: Text(entry.value.name),
                      subtitle: Text(entry.value.quantity),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveCocktail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(widget.cocktail == null ? 'Add Cocktail' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SectionCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Divider(height: 16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

// removed hero header and chips UI per request