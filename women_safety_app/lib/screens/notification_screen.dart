import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/color.dart';
import 'dart:convert';
import 'package:Rakshika/main.dart';

class NotificationItem {
  int id;
  Object user;
  Object user_notify;
  String message;
  DateTime created_at;

  NotificationItem(
      {required this.id,
      required this.user,
      required this.user_notify,
      required this.message,
      required this.created_at});
}
// List<NotificationItem> dummyNotifications = [
//   NotificationItem(
//     message: "You received a new message",
//     sender: "ABC",
//     timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
//   ),
// ];

Future<List<NotificationItem>> getNotif(String? authToken) async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/network/user-notify/'),
    headers: {
      'accept': 'application/json',
      // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    final notifs = data.map<NotificationItem>((NotifData) {
      return NotificationItem(
        id: NotifData['id'],
        user: NotifData['user'],
        user_notify: NotifData['user_notify'],
        message: NotifData['message'] ?? "",
        created_at: DateTime.parse(NotifData['created_at']),
      );
    }).toList();
    print("Not printing");
    print(notifs);
    return notifs;
  } else {
    print("response code : ${response.statusCode}");
    throw Exception('Failed to load notifs');
  }
}

Future<List<NotificationItem>> getHelpNotif(String? authToken) async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/network/notification/1/'),
    headers: {
      'accept': 'application/json',
      // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    final helpnotifs = data.map<NotificationItem>((HelpNotifData) {
      return NotificationItem(
        id: HelpNotifData['id'],
        user: HelpNotifData['user'],
        user_notify: HelpNotifData['user_notify'],
        message: HelpNotifData['message'] ?? "",
        created_at: DateTime.parse(HelpNotifData['created_at']),
      );
    }).toList();
    print("Not printing");
    print(helpnotifs);
    return helpnotifs;
  } else {
    print("response code : ${response.statusCode}");
    throw Exception('Failed to load help notifs');
  }
}

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
  // final FlutterSecureStorage storage;
  // const NotificationScreen({super.key, required this.storage});
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

  // FlutterSecureStorage get storage => widget.storage;
  List<NotificationItem> NotifDisplay = [];
  List<NotificationItem> HelpNotifDisplay = [];

  Future<void> NotifUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    // String ACCESS_LOGIN =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk0NTA5ODkzLCJpYXQiOjE2OTE5MTc4OTMsImp0aSI6IjY5ZjcyYzc4ODlmNjQxNTg5MGZmM2Q2MmU4NjAyOGNjIiwidXNlcl9pZCI6MjB9.3aIYehAhJQJLFBSn_I759zE247O8KmOMiVWHnYkK6BM";
    getNotif(ACCESS_LOGIN).then((notif) {
      setState(() {
        NotifDisplay = notif;
      });
    });
    // print(NotifDisplay);
  }

  Future<void> HelpNotifUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    // String ACCESS_LOGIN =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk0NTA5ODkzLCJpYXQiOjE2OTE5MTc4OTMsImp0aSI6IjY5ZjcyYzc4ODlmNjQxNTg5MGZmM2Q2MmU4NjAyOGNjIiwidXNlcl9pZCI6MjB9.3aIYehAhJQJLFBSn_I759zE247O8KmOMiVWHnYkK6BM";
    getHelpNotif(ACCESS_LOGIN).then((helpnotif) {
      setState(() {
        HelpNotifDisplay = helpnotif;
      });
    });
    // print(NotifDisplay);
  }

  @override
  void initState() {
    super.initState();
    NotifUpdate();
    HelpNotifUpdate();
  }

  void _removeNotification(int id) async {
    String? token = await storage.read(key: 'access_login');
    // String token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk0NTA5ODkzLCJpYXQiOjE2OTE5MTc4OTMsImp0aSI6IjY5ZjcyYzc4ODlmNjQxNTg5MGZmM2Q2MmU4NjAyOGNjIiwidXNlcl9pZCI6MjB9.3aIYehAhJQJLFBSn_I759zE247O8KmOMiVWHnYkK6BM";
    final response = await http.delete(
      Uri.parse('https://rakshika.onrender.com/network/notification/${id}/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 202) {
      await HelpNotifUpdate();
      await NotifUpdate();
      print('Request success with status: ${response.statusCode}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Widget _buildNotificationItem(int index) {
    final notification = NotifDisplay[index];
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
          children: [
            Expanded(
              child: Column(
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
                    "From: ${notification.user} - ${_getTimeAgo(notification.created_at)}",
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _removeNotification(notification.id);
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildNotificationItem(int index) {
  //   final notification = NotifDisplay[index];
  //   return InkWell(
  //     onTap: () {
  //       // Implement what happens when the user taps on a notification item.
  //       _speak(notification.message);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey, width: 1.0),
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //       padding: const EdgeInsets.all(16.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 notification.message,
  //                 style: const TextStyle(
  //                   fontSize: 18.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 8.0),
  //               Text(
  //                   "From: ${notification.user} - ${_getTimeAgo(notification.created_at)}"),
  //             ],
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               _removeNotification(notification.id);
  //             },
  //             child: const Icon(Icons.delete),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildtrustItemWidget(int index) {
    final helpnotification = HelpNotifDisplay[index];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: 40.0,
              color: rBottomBar,
            ),
            title: Text("${helpnotification.user} needs help"),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () {
                  _handleCheckedIconClick1(helpnotification.id);
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              GestureDetector(
                onTap: () {
                  _handleCancelIconClick(helpnotification.id);
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
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
            ListView.builder(
              itemCount: HelpNotifDisplay.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildtrustItemWidget(index);
              },
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              itemCount: NotifDisplay.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildNotificationItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancelIconClick(int id) async {
    String? token = await storage.read(key: "access_login");
    // String token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk0NTA5ODkzLCJpYXQiOjE2OTE5MTc4OTMsImp0aSI6IjY5ZjcyYzc4ODlmNjQxNTg5MGZmM2Q2MmU4NjAyOGNjIiwidXNlcl9pZCI6MjB9.3aIYehAhJQJLFBSn_I759zE247O8KmOMiVWHnYkK6BM";
    final response = await http.delete(
      Uri.parse(
          'https://rakshika.onrender.com/network/notification/accept/${id}/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 202) {
      await HelpNotifUpdate();
      await NotifUpdate();
      print('Request success with status: ${response.statusCode}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void _handleCheckedIconClick1(int id) async {
    String? token = await storage.read(key: 'access_login');
    // String token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjk0NTA5ODkzLCJpYXQiOjE2OTE5MTc4OTMsImp0aSI6IjY5ZjcyYzc4ODlmNjQxNTg5MGZmM2Q2MmU4NjAyOGNjIiwidXNlcl9pZCI6MjB9.3aIYehAhJQJLFBSn_I759zE247O8KmOMiVWHnYkK6BM";
    final response = await http.post(
      Uri.parse(
          'https://rakshika.onrender.com/network/notification/accept/${id}/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await HelpNotifUpdate();
      await NotifUpdate();
      print('Request success with status: ${response.statusCode}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}
