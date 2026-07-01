// lib/features/my_plans/presentation/my_plans_screen.dart
import 'package:flutter/material.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Plans')),
      body: const Center(child: Text('My Plans')),
    );
  }
}
