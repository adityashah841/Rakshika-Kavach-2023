import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/components/bottom_bar.dart';
import 'package:women_safety_app/components/bottom_bar_admin.dart';
import 'package:women_safety_app/components/bottom_bar_male.dart';
import 'package:women_safety_app/screens/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

// String? GENDER;
// String? ACCESS_REGISTER;
// String? USERNAME;
// String? ACCESS_LOGIN;

class LoginScreen extends StatefulWidget {
  final FlutterSecureStorage storage;
  const LoginScreen({super.key, required this.storage});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FlutterSecureStorage storage;
  // _LoginScreenState({required this.storage});
  FlutterSecureStorage get storage => widget.storage;
  String? username;
  String? password;
  bool remember = false;
  final RegExp usernameRegExp =
      RegExp(r'^(?![_\-])(?!.*[_\-]{2})[a-zA-Z0-9_\-]{3,30}(?<![_\-])$');
  final _formkey = GlobalKey<FormState>();
  final List<String> errors = [];

  Future<Map<String, dynamic>> loginUser(String phone, String password) async {
    final url = Uri.parse('https://rakshika.onrender.com/account/login/');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'phone': phone, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Handle successful response
      final data = jsonDecode(response.body);
      // print(data);
      return data;
    } else {
      // Handle error response
      // print(response.body);
      throw Exception(response.body);
      // addError(error: 'Invalid OTP');
      // return {};
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  bool containsUpperCase(String value) {
    return value.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowerCase(String value) {
    return value.contains(RegExp(r'[a-z]'));
  }

  bool containsDigit(String value) {
    return value.contains(RegExp(r'[0-9]'));
  }

  Future<void> _checkAndRequestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    final locationStatus = await Permission.location.request();
    final contactsStatus = await Permission.contacts.request();

    if (cameraStatus != PermissionStatus.granted ||
        microphoneStatus != PermissionStatus.granted ||
        locationStatus != PermissionStatus.granted ||
        contactsStatus != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content:
                Text('Please grant all required permissions to use the app.'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SvgPicture.asset(
                  'assets/illustrations/login.svg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Log-in',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //UserName
                          //Alphanumeric Characters
                          //hyphen and dash allowed but not at beginning and end
                          //length from 3 to 30 characters
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(
                                    error: "Please enter your phone number");
                              }
                              if (value.length == 10) {
                                removeError(
                                    error:
                                        "Phone number must be 10 digits long");
                              }
                              if (containsDigit(value)) {
                                removeError(
                                    error: "Invalid phone number format");
                              }
                              // Store the username value in a variable (if required)
                              username = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(
                                    error: "Please enter your phone number");
                                return "";
                              } else if (value.length != 10) {
                                addError(
                                    error:
                                        "Phone number must be 10 digits long");
                                return "";
                              } else if (!containsDigit(value)) {
                                addError(error: "Invalid phone number format");
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text("Phone Number"),
                              hintText: "Enter Phone Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  gapPadding: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  gapPadding: 10),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          //Password
                          // 8 characters long
                          // Contains at least one uppercase letter (A-Z)
                          // Contains at least one lowercase letter (a-z)
                          // Contains at least one digit (0-9)
                          TextFormField(
                            onSaved: (newValue) => password = newValue,
                            obscureText: true,
                            onChanged: (value) {
                              if (value.length >= 8) {
                                removeError(error: "Password is too short");
                              } else {
                                addError(error: "Password is too short");
                              }
                              if (value.isNotEmpty) {
                                removeError(
                                    error: "Please enter your password");
                              } else {
                                addError(error: "Please enter your password");
                              }
                              if (containsUpperCase(value) &&
                                  containsLowerCase(value) &&
                                  containsDigit(value)) {
                                removeError(error: "Invalid format");
                              } else {
                                addError(error: "Invalid format");
                              }
                              password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: "Please enter your password");
                                return "";
                              } else if (value.length < 8) {
                                addError(error: "Password is too short");
                                return "";
                              }
                              if (!containsUpperCase(value) ||
                                  !containsLowerCase(value) ||
                                  !containsDigit(value)) {
                                addError(error: "Invalid format");
                                return "";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: const Text("Password"),
                              hintText: "Enter your password",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  gapPadding: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  gapPadding: 10),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // String? gender;
                              final u = loginUser(username!, password!);
                              // final then = u.then((value) =>
                              //     saveObject(value, 'user_login'));
                              // u.then((value) => GENDER = value['gender']);
                              var x = await u;
                              await storage.write(
                                  key: 'access_login', value: x["access"]);
                              await storage.write(
                                  key: 'gender', value: x["gender"]);
                              setState(() {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState!.save();
                                  // backend
                                  // GENDER = x["gender"];
                                  // print('gendervijay $GENDER');
                                  // u.then((value) =>
                                  //     ACCESS_LOGIN = value["access"]);
                                  // ACCESS_LOGIN = x["access"];
                                  // print('accessvijay $ACCESS_LOGIN');
                                  // then.then((value) => print(value));
                                }
                              });
                              String? GENDER =
                                  await storage.read(key: 'gender');

                              if (errors.isNotEmpty) {
                                String errorText = errors.join(
                                    "\n"); // Concatenate error messages with a newline separator
                                Fluttertoast.showToast(
                                  msg: errorText,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              } else {
                                print('gender: $GENDER');
                                // gender ??= 'Female';
                                _checkAndRequestPermissions();
                                if (GENDER == 'Female') {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BottomPage(storage: storage),
                                    ),
                                  );
                                } else if (GENDER == 'Male') {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BottomPageMale(storage: storage),
                                    ),
                                  );
                                } else if (GENDER == 'Admin') {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BottomPageAdmin(
                                        storage: storage,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegisterScreen(
                                            storage: storage,
                                          )));
                                },
                                child: const Text(
                                  'Not a member? Register',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}