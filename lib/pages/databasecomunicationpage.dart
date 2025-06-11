import 'package:MemoCocktail/pages/addCocktailForm.dart';
import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/modifyCocktailpage.dart';
import 'package:MemoCocktail/pages/addNewMenu.dart';
import 'package:MemoCocktail/pages/ModifyMenu.dart';

class Databasecomunicationpage extends StatelessWidget {
  const Databasecomunicationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              'Cocktail Management',
              [
                _buildButton(
                  'Add New Cocktail',
                  Icons.add_circle_outline,
                  'Create and add new cocktails to the database',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCocktailForm()),
                    );
                  },
                ),
                _buildButton(
                  'Modify Cocktail',
                  Icons.edit,
                  'Edit or delete existing cocktails',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ModifyCocktailPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Menu Management',
              [
                _buildButton(
                  'Add New Menu',
                  Icons.add_box_outlined,
                  'Create new menus with selected cocktails',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddMenuForm()),
                    );
                  },
                ),
                _buildButton(
                  'Modify Menu',
                  Icons.edit_note,
                  'Edit or delete existing menus',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ModifyMenu()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...buttons,
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, String description, VoidCallback onPressed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.deepPurpleAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}