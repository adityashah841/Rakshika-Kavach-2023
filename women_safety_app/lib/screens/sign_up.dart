import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Rakshika/screens/log_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Rakshika/main.dart';

class SignupScreen extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // final FlutterSecureStorage storage;
  // _SignupScreenState({required this.storage});
  // FlutterSecureStorage get storage => widget.storage;
  String? username;
  String? password;
  String? confirmPassword;
  bool _obscureText = true;
  String selectedLanguage = "English";
  final RegExp usernameRegExp =
      RegExp(r'^(?![_\-])(?!.*[_\-]{2})[a-zA-Z0-9_\-]{3,30}(?<![_\-])$');

  final _formkey = GlobalKey<FormState>();
  final List<String> errors = [];

  Future<void> setLoginCreds(
      String username, String password, String authToken) async {
    final url =
        Uri.parse('https://rakshika.onrender.com/account/set-login-creds/');
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken'
    };
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 202) {
      throw Exception(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Container(
          //   color: Colors.transparent,
          // ),
          const Opacity(opacity: 0.1),
          Container(
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(''),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      SvgPicture.asset(
                        'assets/illustrations/create.svg',
                        height: 185,
                        width: 185,
                      ),
                      const Text(
                        'Create your Account',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.5),
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
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      removeError(
                                          error: "Please enter your username");
                                    }
                                    if (value.length >= 3 &&
                                        value.length <= 30) {
                                      removeError(
                                          error:
                                              "Username must be between 3 and 30 characters long");
                                    }
                                    if (usernameRegExp.hasMatch(value)) {
                                      removeError(
                                          error: "Invalid username format");
                                    }
                                    // Store the username value in a variable (if required)
                                    username = value;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      addError(
                                          error: "Please enter your username");
                                      return "";
                                    } else if (value.length < 3 ||
                                        value.length > 30) {
                                      addError(
                                          error:
                                              "Username must be between 3 and 30 characters long");
                                      return "";
                                    } else if (!usernameRegExp
                                        .hasMatch(value)) {
                                      addError(
                                          error: "Invalid username format");
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
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                    'Username should have be greater then 3 characters'),
                                const SizedBox(
                                  height: 15,
                                ),
                                //Password
                                TextFormField(
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    if (value.length >= 8) {
                                      removeError(
                                          error: "Password is too short");
                                    } else {
                                      addError(error: "Password is too short");
                                    }
                                    if (value.isNotEmpty) {
                                      removeError(
                                          error: "Please enter your password");
                                    } else {
                                      addError(
                                          error: "Please enter your password");
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
                                      addError(
                                          error: "Please enter your password");
                                      return "";
                                    } else if (value.length < 8) {
                                      addError(
                                          error:
                                              "Password is too short"); // Update the error message
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
                                  onSaved: (newValue) => password = newValue,
                                  decoration: InputDecoration(
                                    label: const Text("Password"),
                                    hintText: "Enter Password",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 42, vertical: 20),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                    'Minimum length 8 characters, must contain atleast one capital and one small alphabet and one number'),
                                const SizedBox(
                                  height: 15,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //Re-enter Password
                                TextFormField(
                                  obscureText: _obscureText,
                                  onSaved: (newValue) =>
                                      confirmPassword = newValue,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      removeError(
                                          error:
                                              "Please confirm your password");
                                    }
                                    if (password == value) {
                                      removeError(
                                          error: "Passwords don't match");
                                    } else {
                                      addError(error: "Passwords don't match");
                                    }
                                    confirmPassword = value;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      addError(
                                          error:
                                              "Please confirm your password");
                                      return "";
                                    } else if (password != value) {
                                      addError(error: "Passwords don't match");
                                      return "";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    label: const Text("Re-enter Password"),
                                    hintText: "Enter Password again",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 42, vertical: 20),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        gapPadding: 10),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        )),
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                //Dropdown
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Choose Language",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedLanguage,
                                        onChanged: (newValue) {
                                          // Update the selected language when an option is chosen
                                          setState(() {
                                            selectedLanguage = newValue!;
                                          });
                                        },
                                        items: <String>['English', 'Hindi']
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          },
                                        ).toList(),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Choose Language",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      String? ACCESS_REGISTER = await storage
                                          .read(key: 'access_register');
                                      setState(() {
                                        if (_formkey.currentState?.validate() ??
                                            false) {
                                          _formkey.currentState!.save();
                                          //  logic (backend)
                                          // final u = getObject('user_register');
                                          // u.then((value) => {
                                          //       setLoginCreds(username!,
                                          //           password!, value['access']),
                                          //     });
                                          setLoginCreds(username!, password!,
                                              ACCESS_REGISTER!);
                                        }
                                      });

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
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Log-In')),
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
          ),
        ],
      ),
    );
  }
}
