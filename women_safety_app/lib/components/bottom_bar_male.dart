import 'package:flutter/material.dart';
import 'package:Rakshika/screens/blog.dart';
import 'package:Rakshika/screens/chat_bot_screen.dart';
import 'package:Rakshika/screens/community_chat.dart';
import 'package:Rakshika/screens/fake_call_screen.dart';
import 'package:Rakshika/screens/near_me_screen.dart';
import 'package:Rakshika/utils/color.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/main.dart';

class BottomPageMale extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const BottomPageMale({
    super.key,
  });

  @override
  State<BottomPageMale> createState() => _BottomPageMaleState();
}

class _BottomPageMaleState extends State<BottomPageMale> {
  // FlutterSecureStorage get storage => widget.storage;
  int currentIndex = 2;
  // List<Widget> pages = [
  //   const NearMeScreen(),
  //   const BlogScreen(),
  //   const CommunityChatScreen(),
  //   const FakeCallScreen(),
  //   const ChatBotScreen(),
  // ];
  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    pages = [
      const NearMeScreen(),
      const BlogScreen(),
      const CommunityChatScreen(),
      const FakeCallScreen(),
      const ChatBotScreen(),
    ];
  }

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
            label: "Blogs",
            icon: Icon(Icons.bookmarks_sharp),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Warriors",
            icon: Icon(Icons.security),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Fake Call",
            icon: Icon(Icons.call),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "ChatBot",
            icon: Icon(Icons.boy_outlined),
            backgroundColor: rBottomBar,
          ),
        ],
      ),
    );
  }
}
