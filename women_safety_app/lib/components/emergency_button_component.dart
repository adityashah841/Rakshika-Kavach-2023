import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyButton extends StatefulWidget {
  final List<String> contacts;

  const EmergencyButton({Key? key, required this.contacts}) : super(key: key);

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonSize = constraints.maxWidth * 0.9;
        final fontSize = buttonSize * 0.12;

        return GestureDetector(
          onDoubleTap: () async {
            for (String contact in widget.contacts) {
              await sendWhatsapp(contact);
            }
          },
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  'Alert',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Position> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
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

  Future<void> sendWhatsapp(String phoneNo) async {
    Position position = await _getCurrentLocation();

    String message = 'Emergency Alert!\n\n';
    message += 'I need help! Please contact me urgently.\n\n';
    message += 'My current location is:\n';
    message += 'Latitude: ${position.latitude}\n';
    message += 'Longitude: ${position.longitude}\n';

    String whatsappUrl =
        "https://wa.me/$phoneNo?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      Fluttertoast.showToast(
        msg: 'Could not launch WhatsApp.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
