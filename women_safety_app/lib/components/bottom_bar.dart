import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/chat_bot_screen.dart';
import 'package:women_safety_app/screens/fake_call_screen.dart';
import 'package:women_safety_app/screens/near_me_screen.dart';
import 'package:women_safety_app/screens/safe_nav_screen.dart';
import 'package:women_safety_app/screens/home_screen.dart';
import 'package:women_safety_app/utils/color.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 2;
  List<Widget> pages = [
    const NearMeScreen(),
    const SafeNavScreen(),
    const StartScreen(),
    const FakeCallScreen(),
    const ChatBotScreen(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTapped,
        elevation: 8.0,
        showSelectedLabels: true,
        selectedItemColor: rBottomNavigationBarItem,
        unselectedItemColor: rUnselectedItemColor,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        items: const [
          BottomNavigationBarItem(
            label: "Near Me",
            icon: Icon(Icons.near_me),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "SafeNav",
            icon: Icon(Icons.location_on),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.space_dashboard_rounded),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Fake Call",
            icon: Icon(Icons.call),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Chat Bot",
            icon: Icon(Icons.chat_outlined),
            backgroundColor: rBottomBar,
          ),
        ],
      ),
    );
  }
}
