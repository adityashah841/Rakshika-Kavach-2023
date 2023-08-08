import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/screens/sign_up.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? aadharnumber;
  String? otp;
  bool showOtpField = false;
  final RegExp aadharNumberRegExp = RegExp(r'^\d{4} \d{4} \d{4}$');
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
        title: const Text('Register-Verify'),
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
                            // maxLength: 12,
                            maxLength:
                                14, // Set a maximum of 19 characters (including spaces)
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _AadharNumberFormatter(), // Add your custom formatter
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(
                                    error: 'Please enter Aadhar number');
                              } else {
                                addError(error: 'Please enter Aadhar number');
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
                              // If the value is not empty, has exactly 12 digits, and matches the regex, no error is added.
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text("AadharNumber"),
                              hintText: "Enter your AadharNumber",
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
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() ?? false) {
                                _formkey.currentState!.save();
                                // Perform the logic to get OTP here...
                                setState(() {
                                  showOtpField = true;
                                });
                              } else {
                                // If the form is not valid, display Aadhar-related errors
                                String errorText = errors
                                    .where((error) => error.contains('Aadhar'))
                                    .join(
                                        "\n"); // Concatenate Aadhar-related error messages with a newline separator
                                Fluttertoast.showToast(
                                  msg: errorText,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                                setState(() {
                                  showOtpField = false;
                                });
                              }
                            },
                            child: const Text('Get OTP'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //OTP
                          if (showOtpField)
                            TextFormField(
                              // obscureText: true,
                              keyboardType: TextInputType.number,
                              maxLength: 8,
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
                            height: 10,
                          ),
                          // Login button
                          if (showOtpField)
                            ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState!.save();
                                  // Perform the login logic here...
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                } else {
                                  // If the form is not valid, display OTP-related errors
                                  String errorText = errors
                                      .where((error) => error.contains('OTP'))
                                      .join(
                                          "\n"); // Concatenate OTP-related error messages with a newline separator
                                  Fluttertoast.showToast(
                                    msg: errorText,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                  );
                                }
                              },
                              child: const Text('Login'),
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

class _AadharNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    var newText = '';

    // Remove all spaces from the new value
    final sanitizedValue = text.replaceAll(' ', '');

    // Add a space after every 4 digits
    for (var i = 0; i < sanitizedValue.length; i += 4) {
      final end = i + 4;
      if (end <= sanitizedValue.length) {
        newText += '${sanitizedValue.substring(i, end)} ';
      } else {
        newText += sanitizedValue.substring(i);
      }
    }

    return newValue.copyWith(
      text: newText.trim(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
