import 'dart:convert'; // Import this for json decoding
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/components/bottom_bar.dart';
import 'package:women_safety_app/components/bottom_bar_admin.dart';
import 'package:women_safety_app/components/bottom_bar_male.dart';
import 'package:women_safety_app/screens/log_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // String? accessToken;
  // String? gender;

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
    // ACCESS_LOGIN = ACCESS_LOGIN;
    // GENDER = GENDER;
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
