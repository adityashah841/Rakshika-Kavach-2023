import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
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

  List<String> otherAddresses = [
    'Work Address 1',
    'Work Address 2',
    'Home Address 1',
    'Home Address 2',
    'Other Address 1',
    'Other Address 2',
  ];
  Map<String, bool> subtitleVisibility = {}; // New property

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 5),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/user.JPG'),
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
              const SizedBox(height: 5), // Add spacing
              // Heading for Permissions
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
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
                'Allow Contacts Access', // Added
                CupertinoIcons.person_crop_circle, // Correct icon
                contactsToggle, // Added
                (value) {
                  // Added
                  setState(() {
                    // Added
                    contactsToggle = value; // Added
                  }); // Added
                }, // Added
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
    );
  }

  void _showAddressModal(BuildContext context) {
    TextEditingController _addressController = TextEditingController();
    String selectedAddressType = 'Primary';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Work/Office Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Type:'),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedAddressType,
                    onChanged: (String? newValue) {
                      selectedAddressType = newValue!;
                    },
                    items: <String>[
                      'Primary',
                      'Secondary',
                      'Work',
                      'Home',
                      'Other',
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
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
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
          title: Text('Add Emergency Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Phone',
                ),
              ),
              TextField(
                controller: _relationController,
                decoration: InputDecoration(
                  hintText: 'Relation',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                String name = _nameController.text;
                String phone = _phoneController.text;
                String relation = _relationController.text;

                if (phone.length == 10) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
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

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Flexible(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }

  itemProfile1(String title, IconData iconData, List<String> addresses) {
    if (!subtitleVisibility.containsKey(title)) {
      subtitleVisibility[title] = false; // Initialize visibility for this item
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        leading: Icon(iconData),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              subtitleVisibility[title] = !subtitleVisibility[title]!;
            });
          },
          child: Icon(
            subtitleVisibility[title]!
                ? CupertinoIcons.up_arrow
                : CupertinoIcons.down_arrow,
            size: 30,
            color: Colors.grey.shade400,
          ),
        ),
        tileColor: Colors.white,
      ),
    );
  }

  itemProfileToggle(String title, IconData iconData, bool value,
      ValueChanged<bool> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
