import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/chat_screen.dart';
import 'package:women_safety_app/screens/contact_screen.dart';
import 'package:women_safety_app/screens/profile_page.dart';
import 'package:women_safety_app/screens/start_screen.dart';
import 'package:women_safety_app/utils/color.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    const StartScreen(),
    const ContactScreen(),
    const ChatScreen(),
    const ProfilePage(),
    const StartScreen(),
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
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
            label: "Contact",
            icon: Icon(Icons.contacts),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "Chat",
            icon: Icon(Icons.chat),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person_pin_outlined),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "Home Again",
            icon: Icon(Icons.maps_home_work),
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
