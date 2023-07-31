import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/components/blog_slider.dart';
import 'package:women_safety_app/utils/color.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<String> imageList = [
    'assets/images/busStation.png',
    'assets/images/temples.png',
    'assets/images/helpline.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rPurple,
      body: BlogSlider(imageList: imageList),
    );
  }
}
