import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarConstant(),
      backgroundColor: rYellow,
      body: Center(child: Text("Chat page")),
    );
  }
}
