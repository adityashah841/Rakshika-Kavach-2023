import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class FakeCallComponent extends StatefulWidget {
  const FakeCallComponent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FakeCallComponentState createState() => _FakeCallComponentState();
}

class _FakeCallComponentState extends State<FakeCallComponent> {

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
        // await _startRecording();
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
