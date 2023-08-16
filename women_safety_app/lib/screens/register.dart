import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Rakshika/screens/log_in.dart';
import 'package:Rakshika/screens/sign_up.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Rakshika/main.dart';

Future<bool> saveObject(dynamic myObject, String objectName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(myObject);
  bool x = await prefs.setString(objectName, jsonString);
  return x;
}

dynamic getObject(String objectName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(objectName);
  if (jsonString == null) {
    return null;
  }
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return jsonMap;
}

class RegisterScreen extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final FlutterSecureStorage storage;
  // _RegisterScreenState({required this.storage});
  // FlutterSecureStorage get storage => widget.storage;
  String? aadharnumber;
  String? otp;
  bool showOtpField = false;
  final RegExp aadharNumberRegExp = RegExp(r'^\d{12}$');
  final _formkey = GlobalKey<FormState>();
  final List<String> errors = [];

  Future<void> postAadharGetOtp(String aadharNumber) async {
    final url = Uri.parse('https://rakshika.onrender.com/account/signup/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'aadhar_number': aadharNumber});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception(response.body);
      // addError(error: 'Aadhar number');
    }
  }

  Future<Map<String, dynamic>> validateOtp(
      String code, String aadharNumber) async {
    final url =
        Uri.parse('https://rakshika.onrender.com/account/phone-verify/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'code': code, 'aadhar_number': aadharNumber});

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
                  height: 75,
                ),
                SvgPicture.asset(
                  'assets/illustrations/register.svg',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 10,
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
                                12, // Set a maximum of 19 characters (including spaces)
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.digitsOnly,
                            //   _AadharNumberFormatter(), // Add your custom formatter
                            // ],
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
                                postAadharGetOtp(aadharnumber!);
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
                          Row(
                            children: [
                              Visibility(
                                visible: !showOtpField,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    'Already a member? Login',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 14),
                                  ),
                                ),
                              )
                            ],
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
                              onPressed: () async {
                                if (_formkey.currentState?.validate() ??
                                    false) {
                                  _formkey.currentState!.save();
                                  // Perform the login logic here...
                                  final data = validateOtp(otp!, aadharnumber!);
                                  // final then = data.then((value) =>
                                  // saveObject(value, 'user_register'));
                                  // data.then((value) =>
                                  //     ACCESS_REGISTER = value["access"]);
                                  var x = await data;
                                  await storage.write(
                                      key: 'access_register',
                                      value: x["access"]);
                                  // data.then(
                                  //     (value) => USERNAME = value["username"]);
                                  await storage.write(
                                      key: 'username', value: x["username"]);
                                  // then.then((value) => print(value));
                                  // print("Hello!");
                                  // final x = getObject('user_register');
                                  // x.then((value) => print(value));
                                  // print("\n\n");
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

// class _AadharNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final text = newValue.text;
//     var newText = '';
//
//     // Remove all non-digit characters from the new value
//     final sanitizedValue = text.replaceAll(RegExp(r'\D'), '');
//
//     // Add a space after every 4 digits
//     for (var i = 0; i < sanitizedValue.length; i += 4) {
//       final end = i + 4;
//       if (end <= sanitizedValue.length) {
//         newText += '${sanitizedValue.substring(i, end)} ';
//       } else {
//         newText += sanitizedValue.substring(i);
//       }
//     }
//
//     // Maintain the selection after formatting
//     final newSelection = newValue.selection.copyWith(
//       baseOffset: newText.length,
//       extentOffset: newText.length,
//     );
//
//     return TextEditingValue(
//       text: newText.trim(),
//       selection: newSelection,
//     );
//   }
// }
