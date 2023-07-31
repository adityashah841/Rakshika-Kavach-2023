import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/home_screen.dart';
import 'package:women_safety_app/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? phonenumber;
  String? password;
  bool remember = false;
  final RegExp phoneNumberRegExp = RegExp(r'^[0-9]{10}$');
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
        title: const Text('Log-in'),
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
                'Log-in',
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
                        //PhoneNumber
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) => phonenumber = newValue,
                          onChanged: (value) {
                            if (phoneNumberRegExp.hasMatch(value)) {
                              removeError(error: 'Please Enter Valid Number');
                            }
                            if (value.isNotEmpty) {
                              removeError(
                                  error: 'Please Enter your phone number');
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: 'Please Enter your phone number');
                              return "";
                            } else if (!phoneNumberRegExp.hasMatch(value)) {
                              addError(error: 'Please Enter Valid Number');
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Phonenumber"),
                            hintText: "Enter your phone number",
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
                          height: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //Password
                        // At least 8 characters long
                        // Contains at least one uppercase letter (A-Z)
                        // Contains at least one lowercase letter (a-z)
                        // Contains at least one digit (0-9)
                        // May contain special characters
                        TextFormField(
                          onSaved: (newValue) => password = newValue,
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
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            hintText: "Enter your password",
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
                          height: 10,
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
                          height: 30,
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
                                    builder: (context) => const StartScreen()));
                              }
                            },
                            child: const Text('Login')),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
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
    );
  }
}
