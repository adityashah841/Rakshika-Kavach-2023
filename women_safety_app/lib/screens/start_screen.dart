import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rakshika'),
      ),
      body: Container(
        color: rRed,
      ),
    );
  }
}
