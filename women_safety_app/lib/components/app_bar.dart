import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Rakshika/screens/profile_screen.dart';
import 'package:Rakshika/screens/notification_screen.dart';
import 'package:Rakshika/utils/color.dart';

class AppBarConstant extends StatefulWidget implements PreferredSizeWidget {
  const AppBarConstant({super.key});

  @override
  Size get preferredSize => Size.fromHeight(
      MediaQueryData.fromView(PlatformDispatcher.instance.views.first)
              .size
              .height *
          0.071);
  @override
  State<AppBarConstant> createState() => _AppBarConstantState();
}

class _AppBarConstantState extends State<AppBarConstant> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Rakshika'),
      titleTextStyle: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
          color: rBottomNavigationBarItem),
      backgroundColor: rBottomBar,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 3, 0),
            child: const Icon(
              size: 29,
              Icons.notifications_active_outlined,
              weight: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: const Icon(
              Icons.person_rounded,
              size: 29,
            ),
          ),
        ),
      ],
    );
  }
}
