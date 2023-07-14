import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarConstant(),
      backgroundColor: rGreen,
      body: Center(child: Text("Contact page")),
    );
  }
}