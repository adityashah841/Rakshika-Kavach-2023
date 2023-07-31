import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/sign_up.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? aadharnumber;
  String? otp;
  bool remember = false;
  final RegExp aadharNumberRegExp = RegExp(r'^[0-9]{12}$');
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
        title: const Text('Register-Verify'),
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
                'Verify Yourself',
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
                        //AadharNumber
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) => aadharnumber = newValue,
                          onChanged: (value) {
                            if (aadharNumberRegExp.hasMatch(value)) {
                              removeError(
                                  error: 'Please Enter Valid Aadhar Number');
                            }
                            if (value.isNotEmpty) {
                              removeError(
                                  error: 'Please enter your Aadhar number');
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(
                                  error: 'Please enter your Aadhar number');
                              return "";
                            } else if (!aadharNumberRegExp.hasMatch(value)) {
                              addError(
                                  error: 'Please Enter Valid Aadhar Number');
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("AadharNumber"),
                            hintText: "Enter your AadharNumber",
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
                          height: 30,
                        ),
                        //OTP
                        TextFormField(
                          // obscureText: true,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: "Please enter the OTP");
                            }
                            if (value.length == 8) {
                              removeError(
                                  error:
                                      "OTP must be exactly 8 characters long");
                            }
                            // Storing the OTP value in a variable
                            otp = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: "Please enter the OTP");
                              return "";
                            } else if (value.length != 8) {
                              addError(
                                  error:
                                      "OTP must be exactly 8 characters long");
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("OTP"),
                            hintText: "Enter OTP",
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
                          height: 30,
                        ),
                        const SizedBox(
                          height: 40,
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
                                    builder: (context) =>
                                        const SignupScreen()));
                              }
                            },
                            child: const Text('Login')),
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
