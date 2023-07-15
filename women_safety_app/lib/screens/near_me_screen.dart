import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';

class NearMeScreen extends StatelessWidget {
  const NearMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarConstant(),
      backgroundColor: rDarkBlue,
      body: Center(child: Text("Near Me page")),
    );
  }
}