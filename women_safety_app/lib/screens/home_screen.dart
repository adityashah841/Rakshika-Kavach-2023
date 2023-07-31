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
  final List<String> sloganList = [
    'Women safety first!',
    'Empowered women empower women!',
    'Speak up, rise up!',
    'Break the silence, end the violence!',
    'You are strong, you are brave, you are unstoppable!',
    'Safety is a basic human right!',
    'Together we stand, united we protect!',
    'No excuse for abuse!',
    'Empowerment is the key to progress!',
    'Respect, equality, and dignity for all!',
    'Be the change you want to see in the world!',
    'Support, uplift, and inspire!',
    'Raise your voice, make a difference!',
    'Safe women, strong nation!',
    'Stand tall, speak up!',
    'Safety is not negotiable!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: BlogSlider(imageList: imageList, sloganList: sloganList),
    );
  }
}
