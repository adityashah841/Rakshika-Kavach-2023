import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shake/shake.dart';
import 'package:Rakshika/utils/color.dart';

class EmergencyButton extends StatefulWidget {
  final List<String> contacts;

  const EmergencyButton({Key? key, required this.contacts}) : super(key: key);

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  bool isTriggeringEnabled = false;
  ShakeDetector? shakeDetector;
  int shakeCount = 0;
  @override
  void initState() {
    super.initState();

    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          shakeCount++;
          print('Shake count : $shakeCount');
          if (shakeCount >= 3) {
            _getCurrentLocationAndTrigger(widget.contacts);
            shakeCount = 0;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            await _getCurrentLocationAndTrigger(widget.contacts);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                'Alert Contacts',
                style: TextStyle(
                  fontSize: 14.0,
                  color: rBottomBar,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            Switch(
              value: isTriggeringEnabled,
              onChanged: (value) {
                setState(() {
                  isTriggeringEnabled = value;
                });

                if (isTriggeringEnabled) {
                  scheduleAutomaticTriggering();
                  Fluttertoast.showToast(
                    msg: 'Triggering is ON',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  cancelAutomaticTriggering();
                  Fluttertoast.showToast(
                    msg: 'Triggering is OFF',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
              msg:
                  'Location permissions are permanently denied, we cannot request permission');
          return Future.error('Location permissions are permanently denied.');
        }
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _getCurrentLocationAndTrigger(List<String> contacts) async {
    Position position;
    try {
      position = await _getCurrentLocation();
      String message = 'My current location is:\n';
      message += 'Latitude: ${position.latitude}\n';
      message += 'Longitude: ${position.longitude}\n';
      message += 'Click the following link to see my live location:\n';
      message +=
          'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

      TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: dotenv.env['TWILIO_ACCOUNT_SID']!,
        authToken: dotenv.env['TWILIO_AUTH_TOKEN']!,
        twilioNumber: dotenv.env['TWILIO_PHONE_NUMBER']!,
      );

      for (String contact in contacts) {
        try {
          await twilioFlutter.sendSMS(
            toNumber: contact,
            messageBody: message,
          );
          Fluttertoast.showToast(
            msg: 'Alert Sent',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print('SMS sent to $contact');
        } catch (e) {
          // print('Failed to send SMS to $contact: $e');
          Fluttertoast.showToast(
            msg: 'Failed to send SMS to $contact',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error getting location. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Check if the user is at home and set coordinates to (0, 0) if matched
    if (isUserAtHome(position)) {
      position = Position(
        latitude: 0,
        longitude: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        timestamp: DateTime.now(),
        accuracy: double.infinity,
        floor: position.floor,
      );
      // Fluttertoast.showToast(msg: 'User reached home. Triggering is OFF');
    }
    // Do something with the coordinates or send the location to the backend
    // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  bool isUserAtHome(Position position) {
    // Static home coordinates
    double homeLatitude = 19.1619411;
    double homeLongitude = 72.8397202;

    // Define a threshold to consider the user at home (in meters)
    double thresholdDistance = 100.0;

    // Calculate the distance between the current position and home coordinates
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      homeLatitude,
      homeLongitude,
    );

    // If the distance is within the threshold, consider the user at home
    return distance <= thresholdDistance;
  }

  void scheduleAutomaticTriggering() {
    // Check if it's past 10 PM
    DateTime now = DateTime.now();
    if (now.hour >= 22 || now.hour <= 6) {
      triggerAfterInterval(Duration.zero);
      _scheduleNextTrigger();
    } else {
      // Schedule the first trigger at 10 PM
      DateTime tenPM = DateTime(now.year, now.month, now.day, 22, 0, 0);
      Duration initialDelay = tenPM.difference(now);
      triggerAfterInterval(initialDelay);
    }
  }

  void _scheduleNextTrigger() {
    const Duration interval = Duration(minutes: 30);
    Timer.periodic(interval, (Timer timer) async {
      if (isTriggeringEnabled) {
        await _getCurrentLocationAndTrigger(widget.contacts);
      } else {
        timer.cancel();
      }
    });
  }

  void triggerAfterInterval(Duration duration) {
    Timer(duration, () async {
      if (isTriggeringEnabled) {
        await _getCurrentLocationAndTrigger(widget.contacts);
        _scheduleNextTrigger();
      }
    });
  }

  void cancelAutomaticTriggering() {
    Timer.periodic(Duration.zero, (_) {}).cancel();
  }
}
