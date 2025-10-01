import 'package:MemoCocktail/pages/addCocktailForm.dart';
import 'package:flutter/material.dart';
import 'package:MemoCocktail/pages/modifyCocktailpage.dart';
import 'package:MemoCocktail/pages/addNewMenu.dart';
import 'package:MemoCocktail/pages/ModifyMenu.dart';

class Databasecomunicationpage extends StatelessWidget {
  const Databasecomunicationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(),
        body: const TabBarView(
          children: [
            _CocktailsTab(),
            _MenusTab(),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Data-base',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.deepPurpleAccent,
      iconTheme: const IconThemeData(color: Colors.white),
      bottom: const TabBar(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(icon: Icon(Icons.local_bar, color: Colors.white), text: 'Cocktails'),
          Tab(icon: Icon(Icons.restaurant_menu, color: Colors.white), text: 'Menus'),
        ],
      ),
    );
  }
}

class _CocktailsTab extends StatelessWidget {
  const _CocktailsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ActionCard(
            title: 'Add New Cocktail',
            subtitle: 'Create and add new cocktails',
            icon: Icons.add_circle_outline,
            color: Colors.deepPurpleAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCocktailForm()),
              );
            },
          ),
          _ActionCard(
            title: 'Modify Cocktail',
            subtitle: 'Edit or delete existing cocktails',
            icon: Icons.edit,
            color: Colors.orangeAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ModifyCocktailPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenusTab extends StatelessWidget {
  const _MenusTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ActionCard(
            title: 'Add New Menu',
            subtitle: 'Create menus with selected cocktails',
            icon: Icons.add_box_outlined,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMenuForm()),
              );
            },
          ),
          _ActionCard(
            title: 'Modify Menu',
            subtitle: 'Edit or delete existing menus',
            icon: Icons.edit_note,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ModifyMenu()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double cardWidth = width >= 900
        ? (width - 16 * 2 - 12 * 3) / 4
        : width >= 600
            ? (width - 16 * 2 - 12 * 2) / 3
            : (width - 16 * 2 - 12) / 2;

    return SizedBox(
      width: cardWidth.clamp(240, 380),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.16),
                color.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}