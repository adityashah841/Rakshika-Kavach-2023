import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/components/bottom_bar.dart';
import 'package:women_safety_app/components/bottom_bar_admin.dart';
import 'package:women_safety_app/components/bottom_bar_male.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:women_safety_app/screens/log_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:women_safety_app/screens/register.dart';

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
  final storage = const FlutterSecureStorage();
  String? ACCESS_LOGIN;
  String? GENDER;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    _checkTokenAndGender();
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
  }

  @override
  Widget build(BuildContext context) {
    if (ACCESS_LOGIN == null) {
      return LoginScreen(storage: storage);
    } else {
      // gender ??= 'Female';
      if (GENDER == 'Female') {
        return BottomPage(storage: storage);
      } else if (GENDER == 'Male') {
        return BottomPageMale(storage: storage);
      } else {
        return BottomPageAdmin(storage: storage);
      }
    }
  }
}
