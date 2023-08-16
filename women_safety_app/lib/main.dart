import 'dart:async';
// import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/components/bottom_bar.dart';
import 'package:Rakshika/components/bottom_bar_admin.dart';
import 'package:Rakshika/components/bottom_bar_male.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'dart:convert';
import 'package:Rakshika/screens/log_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:Rakshika/screens/register.dart';
// import 'package:workmanager/workmanager.dart';

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
  // Timer? _timer;
  // Position? _lastPosition;

  // void _startSendingLocationUpdates() async {
  //   ACCESS_LOGIN = await storage.read(key: 'access_login');
  //   if (ACCESS_LOGIN != null) {
  //     _listenToPosStream();
  //   }
  // }

  // void _listenToPosStream() {
  //   Geolocator.getPositionStream().listen((Position position) {
  //     if (position != null) {
  //       _lastPosition = position;
  //       if (_timer == null) {
  //         _sendLocationUpdates(ACCESS_LOGIN!, position.latitude.toString(), position.longitude.toString());
  //         _startTimer();
  //       }
  //     }
  //   });
  // }

  // void _startTimer() {
  //   const interval = const Duration(seconds: 30);
  //   _timer = Timer.periodic(interval, (Timer t) => _sendLocationUpdates(ACCESS_LOGIN!, _lastPosition!.latitude.toString(), _lastPosition!.longitude.toString()));
  // }

  // Future<bool> _sendLocationUpdates(String authToken, String latitude, String longitude) async {
  //   // Get the user's current location
  //   print("Getting location...");
  //   // final Position position = await Geolocator.getCurrentPosition();
  //   print("Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}");
  //   print("Sending location to backend...");
  //   const backendUrl = 'https://rakshika.onrender.com';
  //   // Send the location update to the backend
  //   final response = await http.post(
  //     Uri.parse('$backendUrl/location_stream/update_location/'),
  //     body: jsonEncode({
  //       'latitude': latitude.toString(),
  //       'longitude': longitude.toString(),
  //     }),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $authToken'
  //     }
  //   );

  //   // Handle the response from the backend
  //   if (response.statusCode == 200) {
  //     // print(position.latitude.toString());
  //     // print(position.longitude.toString());
  //     print('Location update sent successfully');
  //     return true;
  //   } else {
  //     print('Failed to send location update: ${response.reasonPhrase} ${response.body}');
  //     // throw Exception('Failed to send location update');
  //     return false;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _checkTokenAndGender();
    // _startSendingLocationUpdates();
    // if (ACCESS_LOGIN != null)
    // sendLocationUpdates();
  }

  Future<void> _checkTokenAndGender() async {
    // final x = getObject('user_login');
    // if (x != null) {
    //   final value = await x;
    //   if (value != null) {
    //     final value2 = jsonDecode(jsonEncode(value));
    //      accessToken = value2["access"];
    //      gender = value2["gender"];
    //     setState(() {});
    //   }
    // }
    ACCESS_LOGIN = await storage.read(key: 'access_login');
    GENDER = await storage.read(key: 'gender');
    // if (ACCESS_LOGIN != null)
    // sendLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    if (ACCESS_LOGIN == null) {
      return const LoginScreen();
    } else {
      // gender ??= 'Female';
      if (GENDER == 'Female') {
        return const BottomPage();
      } else if (GENDER == 'Male') {
        return const BottomPageMale();
      } else {
        return const BottomPageAdmin();
      }
    }
  }
}
