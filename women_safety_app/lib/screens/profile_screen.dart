import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Rakshika/utils/color.dart';

void main() {
  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool locationToggle = false;
  bool audioToggle = false;
  bool cameraToggle = false;
  bool nightModeToggle = false;
  bool contactsToggle = false;
  bool notificationsToggle = false;

  List<String> otherAddresses = [
    'Work Address 1',
    'Work Address 2',
    'Home Address 1',
    'Home Address 2',
    'Other Address 1',
    'Other Address 2',
  ];
  Map<String, bool> subtitleVisibility = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Add this line
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rakshika'),
          titleTextStyle: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: rBottomNavigationBarItem),
          backgroundColor: rBottomBar,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 5),
                const CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage('assets/images/user.JPG'),
                ),
                const SizedBox(
                  height: 20,
                ),
                itemProfile(
                  'Name',
                  'Ahad Hashmi',
                  CupertinoIcons.person,
                ),
                const SizedBox(height: 10),
                itemProfile(
                  'Age',
                  '15',
                  CupertinoIcons.clock,
                ),
                const SizedBox(height: 10),
                itemProfile(
                  'Residential Address',
                  'abc address, xyz city',
                  CupertinoIcons.home,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showAddressModal(context);
                  },
                  child: itemProfile1(
                    'Other Address',
                    CupertinoIcons.desktopcomputer,
                    otherAddresses,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showEmergencyContactModal(context);
                  },
                  child: itemProfile1(
                    'Emergency Contacts',
                    CupertinoIcons.bell,
                    ['hello', 'new'],
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Permissions',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Allow for Location',
                  CupertinoIcons.location,
                  locationToggle,
                  (value) {
                    setState(() {
                      locationToggle = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Allow for Audio & Mic',
                  CupertinoIcons.mic,
                  audioToggle,
                  (value) {
                    setState(() {
                      audioToggle = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Allow for Camera',
                  CupertinoIcons.camera,
                  cameraToggle,
                  (value) {
                    setState(() {
                      cameraToggle = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Allow for Notification',
                  CupertinoIcons.bell_circle,
                  // cameraToggle,
                  notificationsToggle,
                  (value) {
                    setState(() {
                      // cameraToggle = value;
                      notificationsToggle = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Allow Contacts Access',
                  CupertinoIcons.person_crop_circle,
                  contactsToggle,
                  (value) {
                    setState(() {
                      contactsToggle = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                itemProfileToggle(
                  'Night Mode',
                  CupertinoIcons.moon,
                  nightModeToggle,
                  (value) {
                    setState(() {
                      nightModeToggle = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddressModal(BuildContext context) {
    TextEditingController _addressController = TextEditingController();
    String selectedAddressType = 'Primary';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Work/Office Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Type:'),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedAddressType,
                    onChanged: (String? newValue) {
                      selectedAddressType = newValue!;
                    },
                    items: <String>[
                      'Home Virar',
                      'Office Dahisar',
                      'D J Sanghvi',
                    ].map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter your address',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String enteredAddress = _addressController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyContactModal(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Emergency Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                ),
              ),
              TextField(
                controller: _relationController,
                decoration: const InputDecoration(
                  hintText: 'Relation',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String name = _nameController.text;
                String phone = _phoneController.text;
                String relation = _relationController.text;

                if (phone.length == 10) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Phone number must be 10 characters long.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: Flexible(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        leading: Icon(iconData, color: Colors.black),
        tileColor: Colors.white,
      ),
    );
  }

  Widget itemProfile1(String title, IconData iconData, List<String> addresses) {
    if (!subtitleVisibility.containsKey(title)) {
      subtitleVisibility[title] = false; // Initialize visibility for this item
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () {
            setState(() {
              subtitleVisibility[title] = !subtitleVisibility[title]!;
            });
          },
          child: Visibility(
            visible: subtitleVisibility[title]!,
            child: Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: addresses.map((address) {
                  return Text(
                    address,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        leading: Icon(iconData, color: Colors.black),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              subtitleVisibility[title] = !subtitleVisibility[title]!;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle the "Add" action here
                  _showAddressModal(context);
                },
                child: const Icon(
                  CupertinoIcons.add,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                subtitleVisibility[title]!
                    ? CupertinoIcons.up_arrow
                    : CupertinoIcons.down_arrow,
                size: 28,
                color: Colors.black,
              ),
            ],
          ),
        ),
        tileColor: Colors.white,
      ),
    );
  }

  Widget itemProfileToggle(String title, IconData iconData, bool value,
      ValueChanged<bool> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(
          iconData,
          color: Colors.black,
        ),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
