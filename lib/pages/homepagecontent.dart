import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cocktail.dart';
import 'package:MemoCocktail/pages/cocktaildetailpage.dart'; // <-- you'll create this next


class Homepagecontent extends StatelessWidget {
  const Homepagecontent({super.key});

  @override
  Widget build(BuildContext context) {
    final cocktailBox = Hive.box<Cocktail>('cocktails');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cocktail List',
          style: TextStyle(
            color: Colors.white
          ),
          ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: cocktailBox.listenable(),
        builder: (context, Box<Cocktail> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No cocktails available.'));
          }

          final cocktails = box.values.toList();

          return ListView.builder(
            itemCount: cocktails.length,
            itemBuilder: (context, index) {
              final cocktail = cocktails[index];
              return ListTile(
                title: Text(cocktail.name),
                // trailing: const Icon(Icons.arrow_forward_ios)r,
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
    );
  }
}