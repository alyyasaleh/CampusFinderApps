import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final int userId;
  final String userName;

  const HomeScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Welcome, $userName!')),
    );
  }
}
