import 'dart:async';
import 'package:Rakshika/screens/splash_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/components/bottom_bar.dart';
import 'package:Rakshika/components/bottom_bar_admin.dart';
import 'package:Rakshika/components/bottom_bar_male.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:Rakshika/screens/log_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// import 'package:Rakshika/screens/register.dart';

final storage = const FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppStart(),
    );
  }
}

class AppStart extends StatefulWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  // final storage = const FlutterSecureStorage();
  String? ACCESS_LOGIN;
  String? GENDER;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    _checkTokenAndGender();
  }

  void sendLocationUpdates() async {
    // Create a new repeating timer that runs every 15 minutes
    Timer.periodic(const Duration(minutes: 15), (Timer timer) async {
      // Get the user's current location
      final Position position = await Geolocator.getCurrentPosition();
      const backendUrl = 'https://rakshika.onrender.com/';
      // Send the location update to the backend
      final response = await http.post(
        Uri.parse('$backendUrl/update-location'),
        body: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );

      // Handle the response from the backend
      if (response.statusCode == 200) {
        print('Location update sent successfully');
      } else {
        print('Failed to send location update: ${response.body}');
        throw Exception('Failed to send location update');
      }
    });
  }

  Future<void> _checkTokenAndGender() async {
    ACCESS_LOGIN = await storage.read(key: 'access_login');
    GENDER = await storage.read(key: 'gender');
  }

//   @override
//   Widget build(BuildContext context) {
//     if (ACCESS_LOGIN == null) {
//       return const LoginScreen();
//     } else {
//       // gender ??= 'Female';
//       if (GENDER == 'Female') {
//         return const BottomPage();
//       } else if (GENDER == 'Male') {
//         return const BottomPageMale();
//       } else {
//         return const BottomPageAdmin();
//       }
//     }
//   }
// }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          if (ACCESS_LOGIN == null) {
            return const LoginScreen();
          } else {
            if (GENDER == 'Female') {
              return const BottomPage();
            } else if (GENDER == 'Male') {
              return const BottomPageMale();
            } else {
              return const BottomPageAdmin();
            }
          }
        }
      },
    );
  }
}
