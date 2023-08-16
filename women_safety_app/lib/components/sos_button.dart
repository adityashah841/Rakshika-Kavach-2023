import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Rakshika/utils/color.dart';
import 'package:camera/camera.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Rakshika/main.dart';

class SOSButton extends StatefulWidget {
  // final FlutterSecureStorage storage;
  const SOSButton({Key? key, required this.contacts,})
      : super(key: key);
  final List<String> contacts;

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  // FlutterSecureStorage get storage => widget.storage;
  bool isClicked = false;
  // late String? cloudinaryUrlAudio;
  // late String? cloudinaryUrlVideo;
  late String videoPath;
  late Record audioRecord = Record();
  late AudioPlayer audioPlayer;
  String audioPath = '';
  final cloudinary = Cloudinary.signedConfig(
    apiKey: dotenv.env['API_KEY']!,
    apiSecret: dotenv.env['API_SECRET']!,
    cloudName: dotenv.env['CLOUD_NAME']!,
  );
  bool isRecording = false;

  Future<void> getNearestUsers(
      String authToken, String latitude, String longitude) async {
    final params = {'latitude': latitude, 'longitude': longitude};
    final url = Uri.parse(
            'https://rakshika.onrender.com/network/community-users-search/')
        .replace(queryParameters: params);
    // final url = Uri.parse(
    //         'http://localhost:8000/network/community-users-search/')
    //     .replace(queryParameters: params);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken'
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to perform community search.');
    }
  }

  Future<String> setEvidence(String authToken, String videoPath,
      String audioPath, String location) async {
    final url = Uri.parse('https://rakshika.onrender.com/evidences/');
    // final url = Uri.parse('http://192.168.33.165:8000/evidences/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken'
    };
    final request = http.MultipartRequest('POST', url);
    // final body = jsonEncode({
    //   'video': videoPath ?? "",k
    //   'audio': audioPath ?? "",
    //   'location': location,
    // });
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
    request.files.add(await http.MultipartFile.fromPath('video', videoPath));
    request.fields['location'] = location;
    // final response = await http.post(url, body: body, headers: headers);
    final response = await request.send();

    if (response.statusCode == 201) {
      final data = response.stream.bytesToString();
      print(data);
      return data;
    } else {
      print(response.reasonPhrase);
      throw Exception('Failed to create evidence.');
    }
  }

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
    _getCurrentLocationAndTrigger(widget.contacts);
    // Initialize the cameras.
    final cameras = await availableCameras();
    final camera = cameras.first;

    // Create a video recording controller.
    final controller = CameraController(camera, ResolutionPreset.high);

    // Initialize the camera controller.
    await controller.initialize();
    await audioRecord.start();
    setState(() {
      isRecording = true;
    });

    // Start the video recording.
    controller.startVideoRecording();

    // Set isClicked to true to change the color to green.
    setState(() {
      isClicked = true;
    });

    // Create a timer to stop the video recording after 3 minutes.
    Timer(const Duration(minutes: 0, seconds: 10), () async {
      // Stop the video recording.
      XFile videoFile = await controller.stopVideoRecording();
      if (isRecording) {
        _stopRecording();
      }

      // Set isClicked back to false to revert the color.
      setState(() {
        isClicked = false;
      });

      // Display a message to the user.
      print("Recording stopped");

      // Save the video to a local file
      final appDir = await getTemporaryDirectory();
      final videoFileName = DateTime.now().toIso8601String();
      final videoPath = '${appDir.path}/$videoFileName.mp4';
      await videoFile.saveTo(videoPath);

      setState(() {
        this.videoPath = videoPath;
      });
      // CloudinaryResponse response = await cloudinary.upload(
      //   file: audioPath,
      //   resourceType: CloudinaryResourceType.raw,
      // );

      // if (response.isSuccessful) {
      //   cloudinaryUrlAudio = response.secureUrl;
      //   print('Cloudinary URL: $cloudinaryUrlAudio');
      // } else {
      //   print('Cloudinary audio upload failed: ${response.error}');
      // }

      // CloudinaryResponse responseVid = await cloudinary.upload(
      //   file: videoPath,
      //   resourceType: CloudinaryResourceType.video,
      // );

      // if (responseVid.isSuccessful) {
      //   cloudinaryUrlVideo = responseVid.secureUrl;
      //   print('Cloudinary URL: $cloudinaryUrlVideo');
      // } else {
      //   print('Cloudinary video upload failed: ${responseVid.error}');
      // }

      final position = await _getCurrentLocation();
      final latitude = position.latitude.toString();
      final longitude = position.longitude.toString();

      final ACCESS_LOGIN = await storage.read(key: 'access_login');
      // final ACCESS_LOGIN_TEMP = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkyMzczMTk2LCJpYXQiOjE2OTIxMTM5OTYsImp0aSI6ImZlY2UxMGUwMTkwOTQyMjM4ODE2YTJhOTNlZjFhYTE2IiwidXNlcl9pZCI6MjB9.PaAoJgTxfTPAM7wCCxsyI-4Cw_L4e6zQfIEVJtJYl8E";
      print(ACCESS_LOGIN);
      print(videoPath);
      print(audioPath);
      print(latitude);
      print(longitude);
      final data = await setEvidence(
          ACCESS_LOGIN!, videoPath, audioPath, '$latitude, $longitude');
      // final data = await setEvidence(
      //     ACCESS_LOGIN_TEMP, videoPath, audioPath, '$latitude, $longitude');
      // Display the saved video
      print(videoPath);
    });
  }

  Future<void> _stopRecording() async {
    String? path = await audioRecord.stop();
    setState(() {
      isRecording = false;
      audioPath = path!;
    });
    print('Recorded audio path: $audioPath');
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
      final latitude = position.latitude.toString();
      final longitude = position.longitude.toString();
      final ACCESS_LOGIN = await storage.read(key: 'access_login');
      await getNearestUsers(ACCESS_LOGIN!, latitude, longitude);
      String message = 'Krish Shah\n\n';
      message += 'Project practice Che Ignore !!\n\n';
      message += 'My current location is:\n';
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
          print('Failed to send SMS to $contact: $e');
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
      print("Some error occurred: $e");
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
    // Do something with the coordinates or send the location to the backend
    // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }
}
