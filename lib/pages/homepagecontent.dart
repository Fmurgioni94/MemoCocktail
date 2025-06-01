import 'package:flutter/material.dart';
import '../services/hive_service.dart';
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {

  final cocktails = HiveService.cocktailBox.values.toList();
 
  return Scaffold(

    body: Column(

      children: [

        const SizedBox(height: 40),

        const Center(

          child: Text(

            'Here are the display of the cocktails',

            style: TextStyle(fontSize: 24),

          ),

        ),

        const SizedBox(height: 20),

        Expanded(

          child: ListView.builder(

            itemCount: cocktails.length,

            itemBuilder: (context, index) {

              final cocktail = cocktails[index];

              return ListTile(

                title: Text(cocktail.name),

                subtitle: Text('${cocktail.ingredients.length} ingredients'),

              );

            },
          ),
        ),
      ],
    ),
  );
}

 
}