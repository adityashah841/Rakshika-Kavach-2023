import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/screens/community_chat.dart';
import 'package:women_safety_app/utils/color.dart';

// import '../utils/color.dart';

class WarriorsBox extends StatelessWidget {
  final FlutterSecureStorage storage;
  const WarriorsBox({Key? key, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CommunityChatScreen(
            storage: storage,
          ),
        ));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
              Icons.security,
              size: 50,
              color: rBottomBar, // Icon color
            ),
            SizedBox(height: 10),
            Text(
              'Rakshika Warriors ', // Box title
              style: TextStyle(
                color: rBottomBar, // Text color
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YourDestinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warriors Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Warriors Page!'),
      ),
    );
  }
}
