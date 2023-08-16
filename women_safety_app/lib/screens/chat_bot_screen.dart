import 'package:flutter/material.dart';
import 'package:Rakshika/utils/color.dart';
// import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: rBottomBar,
        title: const Text('Rakshika'),
        titleTextStyle: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: rBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // dynamic conversationObject = {
          //   'appId':
          //       '249f24603c1ce717303b5a03b076f84f0', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
          // };

          // KommunicateFlutterPlugin.buildConversation(conversationObject)
          //     .then((clientConversationId) {
          //   print("Conversation builder success : " +
          //       clientConversationId.toString());
          // }).catchError(
          //   (error) {
          //     print("Conversation builder error : " + error.toString());
          //   },
          // );
        },
      ),
    );
  }
}
