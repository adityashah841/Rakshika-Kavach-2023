import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
            widthFactor: 0.9,
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
                  color: isClicked ? Colors.red.withOpacity(0.8) : Colors.red,
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
                    '       SOS \n Double Tap \n to activate! ',
                    style: TextStyle(
                      fontSize: 20,
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

  void handleSOS() {
    // Implement the action to be performed when SOS is triggered
    // print('SOS triggered');
    // You can call any function or show an alert or perform any other action here.
  }
}
