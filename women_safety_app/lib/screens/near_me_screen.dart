import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Rakshika/components/app_bar.dart';
import 'package:Rakshika/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NearMeScreen extends StatelessWidget {
  const NearMeScreen({Key? key}) : super(key: key);

  static Future<void> openMap(String location) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
              msg:
                  'Location permissions are permanently denied, we cannot request permission');
          return;
        }
      }
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error getting current location. Please try again later.');
      return;
    }

    String lat = position.latitude.toString();
    String long = position.longitude.toString();
    String googleURL =
        'https://www.google.co.in/maps/search/$location/@$lat,$long,12z';
    final Uri url = Uri.parse(googleURL);
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong! Call Emergency number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rBackground,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/bgImage.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Nearby Services",
              style: TextStyle(
                color: Color.fromARGB(255, 8, 0, 123),
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildServiceBox(
                      image: 'assets/images/policeStation.png',
                      text: "Police Stations",
                      gradientColors: [p1, p1],
                      searchLocation: "Police stations",
                    ),
                    _buildServiceBox(
                      image: 'assets/images/railwayStation.png',
                      text: "Railway",
                      gradientColors: [p1, p1],
                      searchLocation: "Railway stations",
                    ),
                    _buildServiceBox(
                      image: 'assets/images/hospital.png',
                      text: "Hospitals",
                      gradientColors: [p1, p1],
                      searchLocation: "Hospitals",
                    ),
                    _buildServiceBox(
                      image: 'assets/images/busStation.png',
                      text: "Bus Stations",
                      gradientColors: [p1, p1],
                      searchLocation: "Bus stations",
                    ),
                    _buildServiceBox(
                      image: 'assets/images/pharmacies.png',
                      text: "Pharmacies",
                      gradientColors: [p1, p1],
                      searchLocation: "Pharmacies",
                    ),
                    _buildServiceBox(
                      image: 'assets/images/temples.png',
                      text: "Religious",
                      gradientColors: [p1, p1],
                      searchLocation: "Temples",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBox({
    required String image,
    required String text,
    required List<Color> gradientColors,
    required String searchLocation,
    // required double height,
  }) {
    return GestureDetector(
      onTap: () {
        openMap(searchLocation);
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
