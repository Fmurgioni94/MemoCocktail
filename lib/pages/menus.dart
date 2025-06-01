import 'package:flutter/material.dart';

class Menus extends StatelessWidget {
  const Menus({super.key});

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
