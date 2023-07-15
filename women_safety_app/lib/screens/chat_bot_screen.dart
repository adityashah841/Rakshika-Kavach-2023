import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarConstant(),
      backgroundColor: rDarkPink,
      body: Center(child: Text("Chat Bot page")),
    );
  }
}
