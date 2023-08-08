import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/color.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class SOSButton extends StatefulWidget {
  const SOSButton({Key? key}) : super(key: key);

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FractionallySizedBox(
            widthFactor: 0.7,
            child: GestureDetector(
              onDoubleTap: () {
                handleSOS();
              },
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isClicked = true;
                });
              },
              onTapCancel: () {
                setState(() {
                  isClicked = false;
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  isClicked = false;
                });
              },
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                margin: const EdgeInsets.only(bottom: 30, top: 30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isClicked ? Colors.green.withOpacity(0.8) : rSOS,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> handleSOS() async {
    // Initialize the cameras.
    final cameras = await availableCameras();
    final camera = cameras.first;

    // Create a video recording controller.
    final controller = CameraController(camera, ResolutionPreset.high);

    // Initialize the camera controller.
    await controller.initialize();

    // Start the video recording.
    controller.startVideoRecording();

    // Set isClicked to true to change the color to green.
    setState(() {
      isClicked = true;
    });

    // Create a timer to stop the video recording after 3 minutes.
    Timer(Duration(minutes: 1), () {
      // Stop the video recording.
      controller.stopVideoRecording();

      // Set isClicked back to false to revert the color.
      setState(() {
        isClicked = false;
      });

      // Display a message to the user.
      print("Recording stopped");
    });
  }
}
