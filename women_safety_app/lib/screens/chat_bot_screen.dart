import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: rBottomBar,
        title: const Text('Rakshika'),
        titleTextStyle: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: rBackground,
      body: Container(),
    );
  }
}
