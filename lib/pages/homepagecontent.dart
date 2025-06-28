import 'package:MemoCocktail/pages/databasecomunicationpage.dart';
import 'package:MemoCocktail/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import 'package:MemoCocktail/pages/cocktaildetailpage.dart';
import 'package:hive/hive.dart';

class Homepagecontent extends StatefulWidget {
  const Homepagecontent({super.key});

  @override
  State<Homepagecontent> createState() => _HomepagecontentState();
}

class _HomepagecontentState extends State<Homepagecontent> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(context),
      drawer: drawerBurgerMenu(),
      body: body(),
      floatingActionButton: searchActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }

  Drawer drawerBurgerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple
            ),
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Data-base'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Databasecomunicationpage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
            Navigator.pop(context); // 👈 close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          },

          ),
        ],
      ),
    );
  }

  SizedBox searchActionButton(BuildContext context) {
    return SizedBox(
    width: 70,
    height: 70,
    child: FloatingActionButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
      backgroundColor: Colors.deepPurpleAccent, // Background color of the FAB
      foregroundColor: Colors.white, // Default color for the icon (can be overridden below)
      child: Icon(
        Icons.search,
        size: 30,            // Icon size
      ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "MeMo Cocktail",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: [
          PopupMenuButton<String>(
          icon: const Icon(Icons.person, color: Colors.white), 
          onSelected: (value) {
            if (value == 'logout') {
            print('Logging out...');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Log out'),
            ),
          ],
        )
      ],
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  Padding body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome [ UserName ]",
            style: TextStyle(
              color: Colors.deepPurpleAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(height: 24,),
          Expanded(child: _buildTransparentBox(child: const Text("Space repetitions"))),
          const SizedBox(height: 24),
          Expanded(child: _buildTransparentBox(child: const Text("User statistics")))
        ],
      ),
    );
  }
  Widget _buildTransparentBox({ required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:Colors.white.withAlpha((30)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Center(child: child),
    );
  }
}
class CustomSearchDelegate extends SearchDelegate {
  final Box<Cocktail> cocktailBox = Hive.box<Cocktail>('cocktails');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }


  Widget _buildResultsOrSuggestions(BuildContext context) {
    List<Cocktail> filteredCocktails;

    if (query.isEmpty) {
      // Show top 5 suggestions when query is empty
      filteredCocktails = cocktailBox.values.take(5).toList();
    } else {
      filteredCocktails = cocktailBox.values
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    }

    if (filteredCocktails.isEmpty) {
      return const Center(child: Text("No cocktails found."));
    }

    return ListView.builder(
      itemCount: filteredCocktails.length,
      itemBuilder: (context, index) {
        final cocktail = filteredCocktails[index];
        final name = cocktail.name;
        final lowerQuery = query.toLowerCase();
        final matchIndex = name.toLowerCase().indexOf(lowerQuery);

        Widget titleText;
        if (matchIndex != -1 && query.isNotEmpty) {
          // Highlight match
          final beforeMatch = name.substring(0, matchIndex);
          final match = name.substring(matchIndex, matchIndex + query.length);
          final afterMatch = name.substring(matchIndex + query.length);

          titleText = RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 18),
              children: [
                TextSpan(text: beforeMatch),
                TextSpan(
                  text: match,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: afterMatch),
              ],
            ),
          );
        } else {
          titleText = Text(name, style: const TextStyle(fontSize: 18));
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: const Icon(Icons.local_bar, size: 30, color: Colors.deepPurple),
          title: titleText,
          subtitle: Text('${cocktail.methodology} • ${cocktail.glass}'),
          onTap: () {
            close(context, null);
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
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () => query = '',
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, null),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildResultsOrSuggestions(context);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildResultsOrSuggestions(context);
//   }

//   Widget _buildResultsOrSuggestions(BuildContext context) {
//     final cocktailBox = Hive.box<Cocktail>('cocktails');

//     final cocktails = cocktailBox.values
//         .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     if (cocktails.isEmpty) {
//       return const Center(child: Text("No cocktails found."));
//     }

//     return ListView.builder(
//       itemCount: cocktails.length,
//       itemBuilder: (context, index) {
//         final cocktail = cocktails[index];
//         return ListTile(
//           title: Text(cocktail.name),
//           onTap: () {
//             close(context, null);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CocktailDetailPage(cocktail: cocktail),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }