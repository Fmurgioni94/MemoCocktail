import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MeMo Cocktail"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate());
            },
             icon: const Icon(Icons.search),
          )
        ],
      ),
      
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> cocktailTitles = [
  'Harvard',
  'Mai Tai',
  'Clover Club',
  'Belafonte',
  'Stinger',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var cocktail in cocktailTitles) {
      if(cocktail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(cocktail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length, 
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result)
        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var cocktail in cocktailTitles) {
      if(cocktail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(cocktail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length, 
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result)
        );
      },
    );
  }
}