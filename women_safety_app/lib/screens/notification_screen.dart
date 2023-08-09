import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/color.dart';

class NotificationItem {
  String message;
  String sender;
  DateTime timestamp;

  NotificationItem(
      {required this.message, required this.sender, required this.timestamp});
}

List<NotificationItem> dummyNotifications = [
  NotificationItem(
    message: "You received a new message",
    sender: "ABC",
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
];

String _getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else {
    return "${difference.inDays} days ago";
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterTts flutterTts = FlutterTts();

  _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  void _removeNotification(int index) {
    setState(() {
      dummyNotifications.removeAt(index);
    });
  }

  Widget _buildNotificationItem(int index) {
    final notification = dummyNotifications[index];
    return InkWell(
      onTap: () {
        // Implement what happens when the user taps on a notification item.
        _speak(notification.message);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                    "From: ${notification.sender} - ${_getTimeAgo(notification.timestamp)}"),
              ],
            ),
            GestureDetector(
              onTap: () {
                _removeNotification(index);
              },
              child: const Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildtrustItemWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 40.0,
              color: rBottomBar,
            ),
            title: Text('ABC'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              //use icon buttons!
              Icon(
                Icons.check,
                color: Colors.green,
              ),
              SizedBox(
                width: 3,
              ),
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rakshika'),
        titleTextStyle: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: rBottomNavigationBarItem),
        backgroundColor: rBottomBar,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildtrustItemWidget(),
            const SizedBox(height: 16.0),
            ListView.builder(
              itemCount: dummyNotifications.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildNotificationItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
