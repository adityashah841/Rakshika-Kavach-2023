import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
// import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:cloudinary/cloudinary.dart';
// import 'package:cloudinary_public/cloudinary_public.dart' as cloudinary_public;

class FakeCallComponent extends StatefulWidget {
  const FakeCallComponent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FakeCallComponentState createState() => _FakeCallComponentState();
}

class _FakeCallComponentState extends State<FakeCallComponent> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  final cloudinary = Cloudinary.signedConfig(
    apiKey: dotenv.env['API_KEY']!,
    apiSecret: dotenv.env['API_SECRET']!,
    cloudName: dotenv.env['CLOUD_NAME']!,
  );

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      PermissionStatus permissionStatus = await Permission.microphone.request();

      if (permissionStatus.isGranted) {
        Future.delayed(const Duration(seconds: 2), () {});
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });

        // Start a timer to automatically stop recording after 15 seconds
        Future.delayed(const Duration(seconds: 10), () {
          if (isRecording) {
            _stopRecording();
          }
        });
      } else if (permissionStatus.isPermanentlyDenied) {
        Fluttertoast.showToast(
          msg: "Microphone permission permantently denied.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (permissionStatus.isDenied) {
        // Show a toast indicating that permission was denied
        Fluttertoast.showToast(
          msg:
              "Microphone permission denied. Please grant permission to record audio.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error Start Recording : $e ');
      Fluttertoast.showToast(
        msg: "Error Recording",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
      print('Recorded audio path: $audioPath');

      // Upload to Cloudinary
      CloudinaryResponse response = await cloudinary.upload(
        file: audioPath,
        resourceType: CloudinaryResourceType.raw,
      );

      if (response.isSuccessful) {
        String? cloudinaryUrl = response.secureUrl;
        print('Cloudinary URL: $cloudinaryUrl');
        await sendAudioViaTwilio(cloudinaryUrl!);
      } else {
        print('Cloudinary upload failed: ${response.error}');
      }
    } catch (e) {
      print('Error Stop Recording : $e ');
    }
  }

  Future<void> sendAudioViaTwilio(String audioFilePath) async {
    final accountSid = dotenv.env['TWILIO_ACCOUNT_SID']!;
    final authToken = dotenv.env['TWILIO_AUTH_TOKEN']!;
    final twilioPhoneNumber = dotenv.env['TWILIO_PHONE_NUMBER']!;

    final List<String> emergencyContacts = [
      '+919689155601',
      '+919082230267',
    ];

    for (final contact in emergencyContacts) {
      final uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json',
      );

      final response = await http.post(
        uri,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
        },
        body: {
          'From': twilioPhoneNumber,
          'To': contact,
          'body': "The User Fake Call details",
          'MediaUrl': audioFilePath,
        },
      );

      print('Response is ${response.statusCode}: ${response.body}');

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Audio sent as MMS',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to send audio as MMS to $contact',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Failed to send audio as MMS to $contact');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        CallKitParams params = const CallKitParams(
          id: "123abc456def",
          nameCaller: "Krish Shah",
          appName: "Rakshika",
          avatar: "https://i.pravatar.cc/100",
          handle: "+91 7303404505",
          type: 0,
          textAccept: "Accept",
          textDecline: "Decline",
          duration: 300000,
          extra: {'userId': "098xyz765uvw"},
          android: AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            ringtonePath: "system_ringtone_default",
            backgroundColor: "#0955fa",
            backgroundUrl: "https://i.pravatar.cc/500",
            actionColor: "#4CAF50",
            incomingCallNotificationChannelName: "Incoming call",
            missedCallNotificationChannelName: "Missed call",
          ),
          ios: IOSParams(
            iconName: "CallKitLogo",
            handleType: "generic",
            supportsVideo: true,
            maximumCallGroups: 2,
            maximumCallsPerCallGroup: 1,
            audioSessionMode: 'default',
            audioSessionActive: true,
            audioSessionPreferredSampleRate: 44100.0,
            audioSessionPreferredIOBufferDuration: 0.005,
            supportsDTMF: true,
            supportsHolding: true,
            supportsGrouping: false,
            ringtonePath: 'system_ringtone_default',
          ),
        );
        await FlutterCallkitIncoming.showCallkitIncoming(params);
        await _startRecording();
      },
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/callImage.png',
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Fake Call",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "Double Tap here to generate a Fake Call.",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "Call Your Number",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
