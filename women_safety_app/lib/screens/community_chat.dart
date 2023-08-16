import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Rakshika/components/app_bar.dart';
import '../utils/color.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshika/main.dart';

class WarriorItem {
  int id;
  String user_name;
  String warrior_name;

  WarriorItem(
      {required this.id, required this.user_name, required this.warrior_name});
}

Future<List<WarriorItem>> getWarrior(String? authToken) async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/network/accept/1/'),
    headers: {
      'accept': 'application/json',
      // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    final wars = data.map<WarriorItem>((warData) {
      return WarriorItem(
        id: warData['id'],
        user_name: warData['user_name'],
        warrior_name: warData['warrior_name'],
      );
    }).toList();
    print(wars);
    return wars;
  } else {
    throw Exception('Failed to load warriors');
  }
}

class User {
  int id;
  String username;
  int phone_number;

  User({required this.id, required this.username, required this.phone_number});
}

Future<List<User>> getUser(String? authToken) async {
  // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U';
  final response = await http.get(
    Uri.parse('https://rakshika.onrender.com/account/get-users/'),
    headers: {'Authorization': 'Bearer $authToken'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    final use = data.map<User>((useData) {
      return User(
        id: useData['id'],
        username: useData['username'],
        phone_number: useData['phone_number'],
      );
    }).toList();
    print("inprocess");
    print(use);
    return use;
  } else {
    print("inprocess failed");
    throw Exception('Failed to load users');
  }
}

Future<List<WarriorItem>> getWarriorRequests(String? authToken) async {
  final response = await http.get(
    // Uri.parse('http://localhost:8000/blogs/1/'),
    Uri.parse('https://rakshika.onrender.com/network/'),
    headers: {
      'accept': 'application/json',
      // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);
    final wars = data.map<WarriorItem>((warData) {
      return WarriorItem(
        id: warData['id'],
        user_name: warData['user_name'],
        warrior_name: warData['warrior_name'],
      );
    }).toList();
    print("requests : ${wars}");
    return wars;
  } else {
    print("response status : ${response.statusCode}");
    throw Exception('Failed to load warriors');
  }
}

class Following {
  int warriors;
  int volunteer;
  Following({required this.volunteer, required this.warriors});
}

Future<Following> getFollowersFollowing(String? authToken) async {
  // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
  final response = await http.post(
    Uri.parse('https://rakshika.onrender.com/network/count/'),
    headers: {'Authorization': 'Bearer $authToken'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    return Following(
      warriors: data['warriors'],
      volunteer: data['volunteer'],
    );
  } else {
    print('Request failed with status: ${response.statusCode}');
    return Following(warriors: 0, volunteer: 0);
  }
}

class CommunityChatScreen extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const CommunityChatScreen({
    super.key,
  });

  @override
  _CommunityChatScreenState createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  // FlutterSecureStorage get storage => widget.storage;
  List<WarriorItem> myWarriorsDisplay = [];
  List<User> myUserDisplay = [];
  List<WarriorItem> WarriorRequests = [];
  Following follow = Following(warriors: 0, volunteer: 0);

  Future<void> WarriorUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    getWarrior(ACCESS_LOGIN).then((war) {
      setState(() {
        myWarriorsDisplay = war;
      });
    });
  }

  Future<void> UserUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    getUser(ACCESS_LOGIN).then((use) {
      setState(() {
        myUserDisplay = use;
      });
    });
  }

  Future<void> WarriorRequestUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    getWarriorRequests(ACCESS_LOGIN).then((req) {
      setState(() {
        WarriorRequests = req;
      });
    });
    print(WarriorRequests);
  }

  Future<void> FollowUpdate() async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    getFollowersFollowing(ACCESS_LOGIN).then((req) {
      setState(() {
        follow = req;
      });
    });
    print(follow);
  }

  int yourWarriorsCount = 10;

  @override
  void initState() {
    super.initState();
    WarriorUpdate();
    UserUpdate();
    WarriorRequestUpdate();
    FollowUpdate();
    // _getFollowersFollowing();
  }

  Future<void> _postAdd(int phone) async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');
    print(phone);
    // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.post(
        Uri.parse('https://rakshika.onrender.com/network/'),
        headers: {
          'Authorization': 'Bearer $ACCESS_LOGIN',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'phone': phone, // Add the phone parameter to the JSON body
        }));

    if (response.statusCode == 200) {
      await WarriorUpdate();
      await WarriorRequestUpdate();
      await FollowUpdate();
      print("Success in adding wrrior");
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _postAccept(String id) async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');

    // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.post(
      Uri.parse('https://rakshika.onrender.com/network/accept/${id}/'),
      headers: {'Authorization': 'Bearer $ACCESS_LOGIN'},
    );
    print("id : ${id}");
    if (response.statusCode == 200) {
      print('Request accepted successfully');
      await WarriorUpdate();
      await WarriorRequestUpdate();
      await FollowUpdate();
      String responseJsonString = json.encode(
          json.decode(response.body)); // Convert the response JSON to string
      print('Response JSON: $responseJsonString'); // Log the JSON string
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _postReject(String id) async {
    String? ACCESS_LOGIN = await storage.read(key: 'access_login');

    // final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.put(
      Uri.parse('https://rakshika.onrender.com/network/accept/${id}/'),
      headers: {'Authorization': 'Bearer $ACCESS_LOGIN'},
    );
    print("id : ${id}");
    if (response.statusCode == 200) {
      print('Request rejected successfully');
      await WarriorUpdate();
      await WarriorRequestUpdate();
      await FollowUpdate();
      String responseJsonString = json.encode(
          json.decode(response.body)); // Convert the response JSON to string
      print('Response JSON: $responseJsonString'); // Log the JSON string
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Widget _buildtrustItemWidget(int index) {
    final mywarrior = myWarriorsDisplay[index];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: 40.0,
              color: rBottomBar,
            ),
            title: Text("${mywarrior.warrior_name}"),
          ),
        ],
      ),
    );
  }

  Widget _getUsersItemWidget(int index) {
    final myUser = myUserDisplay[index];
    print(myUser);

    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 40.0, color: rBottomBar),
          const SizedBox(height: 8),
          Text("${myUser.username}"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              _postAdd(myUser
                  .phone_number); // Call the function to accept the request
              setState(() {
                print("Button3 pressed");
              });
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  Widget _getWarriorRequests(int index) {
    final item = WarriorRequests[index];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        leading: const Icon(
          Icons.account_circle,
          size: 40.0,
          color: rBottomBar,
        ),
        title: Text("${item.user_name}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _postAccept(item.id
                    .toString()); // Call the function to accept the request
                setState(() {
                  print("Button1 pressed");
                });
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                _postReject(item.id
                    .toString()); // Call the function to accept the request
                setState(() {
                  print("Button1 pressed");
                });
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80.0,
                    color: rBottomBar,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Your warriors',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "${follow.warriors}", // Use your dynamic variable here
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'You being warrior',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "${follow.volunteer}",
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Requests',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              child: WarriorRequests.isEmpty
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'No pending requests',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          child: ListView.builder(
                            itemCount: WarriorRequests.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return _getWarriorRequests(index);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Warriors',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: myWarriorsDisplay.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildtrustItemWidget(index);
              },
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggested Warriors',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: myUserDisplay.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return _getUsersItemWidget(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
