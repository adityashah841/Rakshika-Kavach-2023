import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: rBlue,
      body: Center(child: Text("Profile page")),
    );
  }
}