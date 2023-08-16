import 'package:flutter/material.dart';
import 'package:Rakshika/screens/blog.dart';
// import 'package:Rakshika/screens/community_chat.dart';
import 'package:Rakshika/screens/fake_call_screen.dart';
import 'package:Rakshika/screens/home_screen.dart';
import 'package:Rakshika/screens/near_me_screen.dart';
import 'package:Rakshika/screens/safe_nav_screen.dart';
import 'package:Rakshika/utils/color.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/main.dart';

class BottomPage extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const BottomPage({
    super.key,
  });

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  // FlutterSecureStorage get storage => widget.storage;
  int currentIndex = 2;
  // List<Widget> pages = [
  //   const NearMeScreen(),
  //   const SafeNavScreen(),
  //   const StartScreen(),
  //   const FakeCallScreen(),
  //   const GeneralChatScreen(),
  // ];
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      const NearMeScreen(),
      const SafeNavScreen(),
      const StartScreen(),
      const FakeCallScreen(),
      const BlogScreen()
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
            label: "Blogs",
            icon: Icon(Icons.bookmarks_sharp),
            backgroundColor: rBottomBar,
          ),
        ],
      ),
    );
  }
}
