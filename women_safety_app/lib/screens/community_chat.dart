import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/color.dart';
import 'package:http/http.dart' as http;

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({Key? key}) : super(key: key);

  @override
  _CommunityChatScreenState createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  int yourWarriorsCount = 10;
  List<Map<String, dynamic>> pendingRequests = [];
  List<Map<String, dynamic>> addWarriors = [];
  String responseData = '';

  @override
  void initState() {
    super.initState();
    _fetchDataWithAuthorization();
    _getFollowersFollowing();
    _getUser();
  }

  Future<void> _fetchDataWithAuthorization() async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/network/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      if (parsedData is List) {
        setState(() {
          pendingRequests = List<Map<String, dynamic>>.from(parsedData);
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }


  Future<void> _postAdd(String phone) async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/network/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'phone': phone, // Add the phone parameter to the JSON body
      })
    );

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      if (parsedData is List) {
        setState(() {
          pendingRequests = List<Map<String, dynamic>>.from(parsedData);
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _getUser() async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxNzI4NDU0LCJpYXQiOjE2OTE0NjkyNTQsImp0aSI6ImY3MzYyMzc5Y2I5MTQ1MTM4OWM0MDU2M2ZlMjY3ODE4IiwidXNlcl9pZCI6NX0.LmamNhJ_rMYSSeygaB677gxVCjSBpsxUSjJU0XaHO9U';
    final response = await http.get(
      Uri.parse('https://rakshika.onrender.com/account/get-users/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      if (parsedData is List) {
        setState(() {
          addWarriors = List<Map<String, dynamic>>.from(parsedData);
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _getFollowersFollowing() async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/network/count/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _postAccept(String id) async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxODM0MzEwLCJpYXQiOjE2OTE1NzUxMTAsImp0aSI6IjNlZjdhNmYyYTk0NTRjMTliYzVkN2ZlNTMyMDZmNTFhIiwidXNlcl9pZCI6MX0.0t3z9GC9d7JgHxnifq5Q5tJEuVB8gFf6frpvrb6kPyc';
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/network/accept/${id}/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print("id : ${id}");
    if (response.statusCode == 200) {
      print('Request accepted/rejected successfully');
      String responseJsonString = json.encode(json.decode(response.body)); // Convert the response JSON to string
      print('Response JSON: $responseJsonString'); // Log the JSON string
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void increaseYourWarriorsCount() {
    setState(() {
      yourWarriorsCount++;
    });
  }

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
                        '$responseData["warriors"]' ?? '0',
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
                        '$responseData["volunteer"]' ?? '0',
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
              child: pendingRequests.isEmpty
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
                children: pendingRequests.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        size: 40.0,
                        color: rBottomBar,
                      ),
                      title: Text(item['user_name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _postAccept(json.encode(item['id'])); // Call the function to accept the request
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
                              _postAccept(item['id']); // Call the function to accept the request
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
                }).toList(),
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              padding: const EdgeInsets.all(5.0),
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
                    'Suggested Warriors',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: addWarriors.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final warrior = addWarriors[index];
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
                        const Icon(Icons.account_circle,
                            size: 40.0, color: rBottomBar),
                        const SizedBox(height: 8),
                        Text(warrior['username']),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _postAdd(json.encode(warrior['phone_number'])); // Call the function to accept the request
                            setState(() {
                              print("Button3 pressed");
                            });
                          },
                          child: const Text('Add'),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
