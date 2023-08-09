import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/analysis_precaution.dart';
import 'package:women_safety_app/screens/blog.dart';
import 'package:women_safety_app/screens/fake_call_screen.dart';
import 'package:women_safety_app/screens/prevention.dart';
import 'package:women_safety_app/screens/prosecution.dart';
import 'package:women_safety_app/utils/color.dart';

class BottomPageAdmin extends StatefulWidget {
  const BottomPageAdmin({super.key});

  @override
  State<BottomPageAdmin> createState() => _BottomPageAdminState();
}

class _BottomPageAdminState extends State<BottomPageAdmin> {
  int currentIndex = 2;
  List<Widget> pages = [
    const BlogScreen(),
    const AnalysisScreenPrevention(),
    const AnalysisScreenPre(),
    const AnalysisScreenProsecution(),
    const FakeCallScreen(),
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
            label: "Blogs",
            icon: Icon(Icons.bookmarks_sharp),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Precaution",
            icon: Icon(Icons.pie_chart),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Prevention",
            icon: Icon(Icons.graphic_eq_rounded),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Prosecution",
            icon: Icon(Icons.bar_chart_rounded),
            backgroundColor: rBottomBar,
          ),
          BottomNavigationBarItem(
            label: "Call",
            icon: Icon(Icons.call),
            backgroundColor: rBottomBar,
          ),
        ],
      ),
    );
  }
}
