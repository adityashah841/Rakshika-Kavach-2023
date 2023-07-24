import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
// import 'package:women_safety_app/screens/chat_bot_screen.dart';
import 'package:women_safety_app/screens/community_chat.dart';
import 'package:women_safety_app/utils/color.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class GeneralChatScreen extends StatefulWidget {
  const GeneralChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GeneralChatScreenState createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _slideAnimation1 =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _slideAnimation2 =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CommunityChatScreen()));
                },
                child: SlideTransition(
                  position: _slideAnimation1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: screenHeight * 0.35,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: rLightPink, // Replace with your desired color
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage(
                                'assets/images/commuityChat.png'), // Replace with your image asset
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Community Chat', // Replace with your title
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const ChatBotScreen()));
                  dynamic conversationObject = {
                    'appId':
                        '249f24603c1ce717303b5a03b076f84f0', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
                  };

                  KommunicateFlutterPlugin.buildConversation(conversationObject)
                      .then((clientConversationId) {
                    print("Conversation builder success : " +
                        clientConversationId.toString());
                  }).catchError(
                    (error) {
                      print("Conversation builder error : " + error.toString());
                    },
                  );
                },
                child: SlideTransition(
                  position: _slideAnimation2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: screenHeight * 0.35,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: rPurple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.black,
                            backgroundImage:
                                AssetImage('assets/images/chatBot.png'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Chat Bot',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
