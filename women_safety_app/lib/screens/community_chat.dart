import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import '../utils/color.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  int yourWarriorsCount = 10;
  List<String> pendingRequests = ['User1', 'User2', 'User3'];

  void increaseYourWarriorsCount() {
    setState(() {
      yourWarriorsCount++; // Increment the count
    });
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
                        '$yourWarriorsCount',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'You being warrior',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        //get from api
                        '10',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // SizedBox(height: 20),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              // padding: const EdgeInsets.all(5.0),
              child: pendingRequests.isEmpty
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10), // Add some space
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
                      children: pendingRequests.map((username) {
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
                            title: Text(username),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    increaseYourWarriorsCount();
                                    setState(() {
                                      pendingRequests.remove(username);
                                    });
                                  },
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pendingRequests.remove(username);
                                    });
                                  },
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
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
                          Text('Contact $index'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Add'),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
