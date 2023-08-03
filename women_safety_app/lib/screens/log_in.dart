import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/screens/home_screen.dart';
import 'package:women_safety_app/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username;
  String? password;
  bool remember = false;
  final RegExp usernameRegExp =
      RegExp(r'^(?![_\-])(?!.*[_\-]{2})[a-zA-Z0-9_\-]{3,30}(?<![_\-])$');
  final _formkey = GlobalKey<FormState>();
  final List<String> errors = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Log-in'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 125,
                  width: 125,
                ),
                const Text(
                  'Log-in',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
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
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(
                                    error: "Please enter your username");
                              }
                              if (value.length >= 3 && value.length <= 30) {
                                removeError(
                                    error:
                                        "Username must be between 3 and 30 characters long");
                              }
                              if (usernameRegExp.hasMatch(value)) {
                                removeError(error: "Invalid username format");
                              }
                              // Store the username value in a variable (if required)
                              username = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: "Please enter your username");
                                return "";
                              } else if (value.length < 3 ||
                                  value.length > 30) {
                                addError(
                                    error:
                                        "Username must be between 3 and 30 characters long");
                                return "";
                              } else if (!usernameRegExp.hasMatch(value)) {
                                addError(error: "Invalid username format");
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text("Username"),
                              hintText: "Enter Username",
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
                            height: 20,
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
                              if (value.length == 8) {
                                removeError(
                                    error:
                                        "Password must be exactly 8 characters long");
                              } else {
                                addError(
                                    error:
                                        "Password must be exactly 8 characters long");
                              }

                              if (value.isNotEmpty) {
                                removeError(
                                    error: "Please enter your password");
                              } else {
                                addError(error: "Please enter your password");
                              }

                              if (containsUpperCase(value)) {
                                removeError(
                                    error:
                                        "Password must contain at least one uppercase letter");
                              } else {
                                addError(
                                    error:
                                        "Password must contain at least one uppercase letter");
                              }

                              if (containsLowerCase(value)) {
                                removeError(
                                    error:
                                        "Password must contain at least one lowercase letter");
                              } else {
                                addError(
                                    error:
                                        "Password must contain at least one lowercase letter");
                              }

                              if (containsDigit(value)) {
                                removeError(
                                    error:
                                        "Password must contain at least one digit");
                              } else {
                                addError(
                                    error:
                                        "Password must contain at least one digit");
                              }

                              password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: "Please enter your password");
                                return "";
                              } else if (value.length != 8) {
                                addError(
                                    error:
                                        "Password must be exactly 8 characters long");
                                return "";
                              }

                              if (!containsUpperCase(value)) {
                                addError(
                                    error:
                                        "Password must contain at least one uppercase letter");
                                return "";
                              }

                              if (!containsLowerCase(value)) {
                                addError(
                                    error:
                                        "Password must contain at least one lowercase letter");
                                return "";
                              }

                              if (!containsDigit(value)) {
                                addError(
                                    error:
                                        "Password must contain at least one digit");
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
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState!.save();
                                  // Perform the login logic here...
                                }
                              });

                              if (errors.isNotEmpty) {
                                String errorText = errors.join(
                                    "\n"); // Concatenate error messages with a newline separator
                                Fluttertoast.showToast(
                                  msg: errorText,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const StartScreen(),
                                  ),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()));
                                  },
                                  child: const Text(
                                    'Not a member?Register',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ))
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
