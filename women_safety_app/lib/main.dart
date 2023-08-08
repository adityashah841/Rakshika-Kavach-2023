import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/components/bottom_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:women_safety_app/components/bottom_bar_admin.dart';
import 'package:women_safety_app/components/bottom_bar_male.dart';
import 'package:women_safety_app/screens/log_in.dart';

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
      home: BottomPage(),
    );
  }
}

class AppStart extends StatefulWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  final storage = const FlutterSecureStorage();
  String? accessToken;
  String? gender;

  @override
  void initState() {
    super.initState();
    _checkTokenAndGender();
  }

  Future<void> _checkTokenAndGender() async {
    accessToken = await storage.read(key: 'accessToken');
    gender = await storage.read(key: 'gender');
    
    final initialRoute = accessToken == null ? '/login' : '/home';
    final routes = {
      '/login': (context) => const LoginScreen(),
      '/home': (context) {
        gender ??= 'F';
        if (gender == 'F') {
          return const BottomPage();
        } else if (gender == 'M') {
          return const BottomPageMale();
        } else {
          return const BottomPageAdmin();
        }
      },
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(initialRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
