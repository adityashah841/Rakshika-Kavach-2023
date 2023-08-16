import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/screens/community_chat.dart';
import 'package:Rakshika/utils/color.dart';
import 'package:Rakshika/main.dart';

// import '../utils/color.dart';

class WarriorsBox extends StatelessWidget {
  // final FlutterSecureStorage storage;
  const WarriorsBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CommunityChatScreen(),
        ));
      },
      child: Container(
        width: 185,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 50,
                color: rBottomBar,
              ),
              SizedBox(height: 10),
              Text(
                'Warriors',
                style: TextStyle(
                  color: rBottomBar,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
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
