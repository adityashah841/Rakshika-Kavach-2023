import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Rakshika/components/app_bar.dart';
import 'package:Rakshika/screens/blog.dart';
import 'package:Rakshika/screens/chat_bot_screen.dart';
import 'package:Rakshika/screens/community_chat.dart';
import 'package:Rakshika/screens/video_call_screen.dart';
import 'package:Rakshika/utils/color.dart';
import 'package:Rakshika/main.dart';

class GeneralChatScreen extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const GeneralChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _GeneralChatScreenState createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen>
    with SingleTickerProviderStateMixin {
  // FlutterSecureStorage get storage => widget.storage;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimationRight;
  late Animation<Offset> _slideAnimationLeft;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimationRight = Tween<Offset>(
      begin: const Offset(1, 0), // Slide from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _slideAnimationLeft = Tween<Offset>(
      begin: const Offset(-1, 0), // Slide from left
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgImage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SlideTransition(
                    position: _slideAnimationLeft,
                    child: _buildBox(
                      'Community Warriors',
                      'assets/images/commuityChat.png',
                      const CommunityChatScreen(),
                      rLightPink,
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimationRight,
                    child: _buildBox(
                      'Chat Bot',
                      'assets/images/chatBot.png',
                      const ChatBotScreen(),
                      rPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SlideTransition(
                    position: _slideAnimationLeft,
                    child: _buildBox(
                      'Blogs',
                      'assets/images/commuityChat.png',
                      const BlogScreen(),
                      rLightPink,
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimationRight,
                    child: _buildBox(
                      'Video Call',
                      'assets/images/chatBot.png',
                      const VideoCallScreen(),
                      rPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String name, String imageAsset, Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.25,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.black,
                backgroundImage: AssetImage(imageAsset),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
