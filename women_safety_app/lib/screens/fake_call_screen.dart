import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/entities.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:Rakshika/components/app_bar.dart';
import 'package:Rakshika/components/fake_call_component.dart';
import 'package:Rakshika/utils/color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  Future<List<String>?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Please enable location services on your device.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg:
                'Location permissions are permanently denied, we cannot request permission');
        return null;
      }
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error getting current location. Please try again later.');
      return null;
    }

    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();

    return [latitude, longitude];
  }

  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/bgImage.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              // _buildFakeCallCard(context),
              const FakeCallComponent(),
              const SizedBox(height: 5.0),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildServiceCard(
                      context,
                      name: "Police",
                      image: 'assets/images/policeImage.png',
                      number: "100",
                    ),
                    _buildServiceCard(
                      context,
                      name: "Ambulance",
                      image: 'assets/images/ambulanceImage.png',
                      number: "102",
                    ),
                    _buildServiceCard(
                      context,
                      name: "Helpline",
                      image: 'assets/images/helpline.png',
                      number: "1091",
                    ),
                    _buildServiceAPICard(
                      context,
                      name: "State Help",
                      image: 'assets/images/helpImage.png',
                      number: "606",
                    ),
                    _buildServiceCard(
                      context,
                      name: "Fire",
                      image: 'assets/images/fireImage.png',
                      number: "101",
                    ),
                    _buildServiceCard(
                      context,
                      name: "Abuse Helpline",
                      image: 'assets/images/domesticAbuse.png',
                      number: "181",
                    ),
                    _buildServiceCard(
                      context,
                      name: "DCP",
                      image: 'assets/images/dcpImage.png',
                      number: "1094",
                    ),
                    _buildServiceCard(
                      context,
                      name: "Air Ambulance",
                      image: 'assets/images/airAmbulance.png',
                      number: "9540161344",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String name,
    required String image,
    required String number,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _callNumber(number);
      },
      child: FractionallySizedBox(
        widthFactor: 1,
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
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
              ),
              const SizedBox(height: 7.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7.0),
              Text(
                "Call: $number",
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Adjust the font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceAPICard(
    BuildContext context, {
    required String name,
    required String image,
    required String number,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _callNumber(number);
      },
      child: FractionallySizedBox(
        widthFactor: 1,
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
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
              ),
              const SizedBox(height: 7.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7.0),
              Text(
                "Call: $number",
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Adjust the font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
