// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:whatsapp/whatsapp.dart';
// import 'package:url_launcher/url_launcher.dart';

// class EmergencyButton extends StatefulWidget {
//   final List contacts;

//   const EmergencyButton({Key? key, required this.contacts}) : super(key: key);

//   @override
//   State<EmergencyButton> createState() => _EmergencyButtonState();
// }

// class _EmergencyButtonState extends State<EmergencyButton> {
//   // WhatsApp whatsapp = WhatsApp();
//   // @override
//   // void initState() {
//   //   whatsapp.setup(
//   //     accessToken: "YOUR_ACCESS_TOKEN_HERE",
//   //     fromNumberId: 917303404504,
//   //   );
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final buttonSize = constraints.maxWidth * 0.3;
//         final fontSize = buttonSize * 0.1;

//         return GestureDetector(
//           onDoubleTap: () async {
//             await sendWhatsappAlert(
//                 widget.contacts.map((contact) => contact.toString()).join(","));
//           },
//           child: FractionallySizedBox(
//             widthFactor: 0.9,
//             child: Container(
//               height: 50,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.red,
//               ),
//               child: Center(
//                 child: Text(
//                   'Alert Contacts',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<Position> _getCurrentLocation() async {
//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Failed to get the user\'s location.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//       rethrow;
//     }
//   }

//   Future<void> sendWhatsappAlert(String phoneNos) async {
//     Position position = await _getCurrentLocation();

//     String message = 'Emergency Alert!\n\n';
//     message += 'I need help! Please contact me urgently.\n\n';
//     message += 'My current location is:\n';
//     message += 'Latitude: ${position.latitude}\n';
//     message += 'Longitude: ${position.longitude}\n';

//     // await whatsapp.short(
//     //   to: phoneNo,
//     //   message: "Hello Flutter",
//     //   compress: true,
//     // );

//     var whatsappUrl = "whatsapp://send?phone=$phoneNos" +
//         "&text=${Uri.encodeComponent(message)}";
//     try {
//       await launchUrl(Uri.parse(whatsappUrl));
//     } catch (err) {
//       Fluttertoast.showToast(
//         msg: 'Could not launch WhatsApp.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }
//   }
// }