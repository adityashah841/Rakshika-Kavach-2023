import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({Key? key}) : super(key: key);

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  bool isTriggeringEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await _getCurrentLocationAndTrigger();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                'Alert Contacts',
                style: TextStyle(
                  fontSize: 14.0,
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
            // const Text('Night Trigger')
          ],
        ),
      ],
    );
  }

  Future<Position> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to get the user\'s location.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      rethrow;
    }
  }

  Future<void> _getCurrentLocationAndTrigger() async {
    Position position;
    try {
      position = await _getCurrentLocation();
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
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
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
        await _getCurrentLocationAndTrigger();
      } else {
        timer.cancel();
      }
    });
  }

  void triggerAfterInterval(Duration duration) {
    Timer(duration, () async {
      if (isTriggeringEnabled) {
        await _getCurrentLocationAndTrigger();
        _scheduleNextTrigger();
      }
    });
  }

  void cancelAutomaticTriggering() {
    Timer.periodic(Duration.zero, (_) {}).cancel();
  }
}
