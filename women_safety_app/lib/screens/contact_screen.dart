import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: rGreen,
      body: Center(child: Text("Contact page")),
    );
  }
}