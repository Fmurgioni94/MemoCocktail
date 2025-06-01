import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Menus extends StatefulWidget {
  const Menus({super.key});

  @override
  State<Menus> createState() => _MenusState();
}


class _MenusState extends State<Menus> {

  Future<void> loadJsonData() async {
  final String jsonString = await rootBundle.loadString('assets/data.json');
  final data = jsonDecode(jsonString);
  print(data); // You can now use it like a Map or List depending on the JSON
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const Center(
        child: Text(
          'This is the Menus Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Menus',
        style: TextStyle(
          color: Colors.white
          ),
        ),
      backgroundColor: Colors.deepPurple,
    );
  }
}

  

  
