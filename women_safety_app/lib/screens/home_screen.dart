import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/components/efir_female_component.dart';
import 'package:women_safety_app/components/emergency_button_component.dart';
import 'package:women_safety_app/components/sos_button.dart';
import 'package:women_safety_app/components/warrior_component.dart';
// import 'package:women_safety_app/utils/color.dart';

class StartScreen extends StatefulWidget {
  final FlutterSecureStorage storage;
  const StartScreen({super.key, required this.storage});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  FlutterSecureStorage get storage => widget.storage;
  // final List<String> imageList = [
  //   'assets/blogs/1.jpg',
  //   'assets/blogs/2.jpg',
  //   'assets/blogs/3.jpg',
  //   'assets/blogs/4.jpg',
  // ];
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

  final List<String> contacts = ['+919689155601', '+919082230267'];
  // Future<void> _requestPermissionsSequentially() async {
  //   bool permissionsRequested = false;

  //   // Location permission
  //   await Permission.location.request();

  //   // Microphone permission
  //   await Permission.microphone.request();

  //   // Camera permission
  //   await Permission.camera.request();

  //   // Contacts permission
  //   await Permission.contacts.request();

  //   setState(() {
  //     permissionsRequested = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // _requestPermissionsSequentially();
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Container(
        decoration: const BoxDecoration(
          // color: rBackground,
          image: DecorationImage(
            image: AssetImage('assets/images/bgImage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // BlogSlider(imageList: imageList, sloganList: sloganList),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WarriorsBox(storage: storage),
                  const SizedBox(width: 15),
                  const EFirFemaleComponent(),
                ],
              ),
            ),
            SOSButton(contacts: contacts, storage: storage),
            EmergencyButton(contacts: contacts),
          ],
        ),
      ),
    );
  }
}
