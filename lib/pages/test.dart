import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: const Center(
        child: Text(
          'This is the Test Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
      'Test',
      style: TextStyle(
        color: Colors.white
      ),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}