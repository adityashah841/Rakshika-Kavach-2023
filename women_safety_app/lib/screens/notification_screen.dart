import 'package:flutter/material.dart';
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
  NotificationItem(
    message: "Your message was sent successfully",
    sender: "Vidhi K",
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
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
  void _removeNotification(int index) {
    setState(() {
      dummyNotifications.removeAt(index);
    });
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
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return InkWell(
            onTap: () {
              // Implement what happens when the user taps on a notification item.
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
        },
      ),
    );
  }
}
