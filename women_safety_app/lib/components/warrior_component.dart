import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:women_safety_app/screens/community_chat.dart';

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
          color: Colors.blue, // Box background color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.shield,
              size: 50,
              color: Colors.white, // Icon color
            ),
            const SizedBox(height: 10),
            Text(
              'Warriors Box', // Box title
              style: TextStyle(
                color: Colors.white, // Text color
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
        title: Text('Warriors Page'),
      ),
      body: Center(
        child: Text('Welcome to the Warriors Page!'),
      ),
    );
  }
}
