import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';

class AppBarConstant extends StatefulWidget implements PreferredSizeWidget {
  const AppBarConstant({super.key});

  @override
  Size get preferredSize => Size.fromHeight(
      MediaQueryData.fromView(PlatformDispatcher.instance.views.first)
              .size
              .height *
          0.0737);
  State<AppBarConstant> createState() => _AppBarConstantState();
}

class _AppBarConstantState extends State<AppBarConstant> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Rakshika'),
          centerTitle: true,
          backgroundColor: rDarkBlue,
          leading: GestureDetector(
            child: const Icon(
              Icons.menu,
            ),
          ),
        ),
      ],
    );
  }
}
