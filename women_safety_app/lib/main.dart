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
// import 'dart:convert';
import 'package:Rakshika/screens/log_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:Rakshika/screens/register.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';

final storage = const FlutterSecureStorage();
final String accessKey =
    "W2Seq1qvSHOkrlveTuVC1ZfdjaclPsWlhm75QrRy2dF09mfj5Po4VA==";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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

  // Define PorcupineManager and other related variables
  late PorcupineManager porcupineManager;
  bool porcupineInitialized = false;

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
    print("PC INTIALISED");
    _initializePorcupine();
    print("PC INTIALISED 1");
    _checkTokenAndGender();
    // _startSendingLocationUpdates();
  }

  Future<void> _initializePorcupine() async {
    try {
      print("Initializing Porcupine...");
      porcupineManager = await PorcupineManager.fromKeywordPaths(
        accessKey,
        
        ["assets/models/keyword.ppn"],
        modelPath: "assets/models/porcupine_params_hi.pv",
        (keywordIndex) {
          if (keywordIndex >= 0) {
            // Keyword detected
            print("Keyword detected: ${keywordIndex}");
          }
        },
      );
      print("Hello $porcupineManager");
      await porcupineManager.start();
      setState(() {
        porcupineInitialized = true; // Mark initialization as completed
      });
      print("Porcupine initialized successfully.");
    } catch (e) {
      print("Porcupine initialization error: ${e.toString()}");
    if (e is PorcupineIOException) {
      // Print Porcupine specific error code and message
      // print("Porcupine Error Code: ${e.errorCode}");
      print("Porcupine Error Message: ${e.message}");
    }
    }
  }

  Future<void> _checkTokenAndGender() async {
    ACCESS_LOGIN = await storage.read(key: 'access_login');
    GENDER = await storage.read(key: 'gender');
  }

  @override
  void dispose() {
    if (porcupineManager != null) {
      porcupineManager.stop();
      porcupineManager.delete();
    }
    super.dispose();
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
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          if (ACCESS_LOGIN == null) {
            FlutterNativeSplash.remove();
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
      future: null,
    );
  }
}
