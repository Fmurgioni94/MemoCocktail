import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'This is the Home Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}