import 'package:flutter/material.dart';

class Training extends StatelessWidget {
  const Training({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const Center(
        child: Text(
          'WORK IN PROGRESS',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      
      title: const Text(
        'Training',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26, 
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.deepPurpleAccent,
    );
  }
}