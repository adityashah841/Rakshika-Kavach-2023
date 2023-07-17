import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            _buildFakeCallCard(context),
            const SizedBox(height: 5.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildServiceCard(
                    name: "Police",
                    description: "Description of the Police service",
                    image: 'assets/images/policeImage.png',
                    number: "909",
                  ),
                  _buildServiceCard(
                    name: "Ambulance",
                    description: "Description of the Ambulance service",
                    image: 'assets/images/ambulanceImage.png',
                    number: "808",
                  ),
                  _buildServiceCard(
                    name: "Nirbhaya",
                    description: "Description of the Nirbhaya service",
                    image: 'assets/images/femalePolice.png',
                    number: "707",
                  ),
                  _buildServiceCard(
                    name: "Help Services",
                    description: "Description of the Help Services",
                    image: 'assets/images/helpImage.png',
                    number: "606",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFakeCallCard(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        CallKitParams params = CallKitParams(
          id: "123abc456def",
          nameCaller: "Krish Shah",
          appName: "Rakshika",
          avatar: "https://i.pravatar.cc/100",
          handle: "+91 7303404505",
          type: 0,
          textAccept: "Accept",
          textDecline: "Decline",
          textMissedCall: "Missed call",
          textCallback: "call back",
          duration: 300000,
          extra: {'userId': "098xyz765uvw"},
          android: const AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            isShowCallback: false,
            isShowMissedCallNotification: true,
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
      },
      child: Container(
        margin: const EdgeInsets.all(16.0),
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
            Image.asset('assets/images/callImage.png'),
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
    );
  }

  Widget _buildServiceCard({
    required String name,
    required String description,
    required String image,
    required String number,
  }) {
    return GestureDetector(
      onTap: () {
        _callNumber(number);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 64.0,
              height: 64.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
            ),
            // Text(
            //   description,
            //   style: const TextStyle(
            //     fontSize: 14.0,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            Text(
              "Call: $number",
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
