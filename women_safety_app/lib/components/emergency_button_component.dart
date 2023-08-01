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
        final buttonSize = constraints.maxWidth * 0.3;
        final fontSize = buttonSize * 0.3;

        return GestureDetector(
          onTap: () async {
            await sendEmergencySMS(widget.contacts);
          },
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  'Alert Contacts',
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

  Future<void> sendEmergencySMS(List<String> recipients) async {
    Position position = await _getCurrentLocation();

    String message = 'Krish Shah\n\n';
    message += 'Project practice Che Ignore !!\n\n';
    message += 'My current location is:\n';
    message += 'Latitude: ${position.latitude}\n';
    message += 'Longitude: ${position.longitude}\n';
    message += 'Click the following link to see my live location:\n';
    message +=
        'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

    try {
      // String uri =
      //     'sms:${recipients.join(",")}?body=${Uri.encodeComponent(message)}';

      // await launchUrl(Uri.parse(uri));
      String uri =
          'sms:${recipients.join(",")}?body=${Uri.encodeComponent(message)}&send=true';
      await launchUrl(Uri.parse(uri));
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to open SMS app.',
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
