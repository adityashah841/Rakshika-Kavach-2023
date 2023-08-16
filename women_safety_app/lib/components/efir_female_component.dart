import 'package:flutter/material.dart';

import '../utils/color.dart';
import 'e_fir_female_screen.dart';

class EFirFemaleComponent extends StatelessWidget {
  const EFirFemaleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const EFirFemaleScreen(),
        ));
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, // Box background color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note_outlined,
              size: 50,
              color: rBottomBar, // Icon color
            ),
            SizedBox(height: 10),
            Text(
              'E-Fir ', // Box title
              style: TextStyle(
                color: rBottomBar, // Text color
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
