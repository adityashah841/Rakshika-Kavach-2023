import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/log_in.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? username;
  String? password;
  String? confirmpassword;
  String selectedLanguage = "English";
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
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
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
                              removeError(error: "Please enter your username");
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
                            } else if (value.length < 3 || value.length > 30) {
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          height: 15,
                        ),
                        //Password
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: "Please enter your password");
                            } else if (value.length >= 8) {
                              removeError(
                                  error:
                                      "Password must be at least 8 characters long");
                            }

                            if (containsUpperCase(value)) {
                              removeError(
                                  error:
                                      "Password must contain at least one uppercase letter");
                            }

                            if (containsLowerCase(value)) {
                              removeError(
                                  error:
                                      "Password must contain at least one lowercase letter");
                            }

                            if (containsDigit(value)) {
                              removeError(
                                  error:
                                      "Password must contain at least one digit");
                            }

                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: "Please enter your password");
                              return "";
                            } else if (value.length == 8) {
                              addError(
                                  error:
                                      "Password must be at least 8 characters long");
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
                          onSaved: (newValue) => password = newValue,
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            hintText: "Enter Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          height: 15,
                        ),
                        //Re-enter Password
                        TextFormField(
                          obscureText: true,
                          onSaved: (newValue) => confirmpassword = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(
                                  error: "Please confirm your password");
                            } else if (value.length == 8 && password == value) {
                              removeError(error: "Passwords don't match");
                            }
                            confirmpassword = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: "Please confirm your password");
                              return "";
                            } else if (value.length < 8) {
                              addError(error: "Password is too short");
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          height: 15,
                        ),
                        //Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Choose Language",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                        Column(
                          children: [
                            for (String? error in errors)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cancel,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(error ?? ""),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState!.save();
                                  // Perform the login logic here...
                                  // If the login is successful, navigate to StartScreen.
                                  // If the login fails, add error messages to the 'errors' list.
                                  // For now, let's add a demo error message for illustration purposes.
                                }
                              });
                              if (errors.isEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                              }
                            },
                            child: const Text('Now Log-In')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
