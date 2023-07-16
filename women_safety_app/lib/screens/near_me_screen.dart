import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';
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
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildServiceBox(
                  image: 'assets/images/policeStation.png',
                  text: "Police Stations",
                  gradientColors: [Colors.lightBlue, Colors.white],
                  searchLocation: "Police stations",
                ),
                _buildServiceBox(
                  image: 'assets/images/railwayStation.png',
                  text: "Railway Stations",
                  gradientColors: [Colors.teal, Colors.white],
                  searchLocation: "Railway stations",
                ),
                _buildServiceBox(
                  image: 'assets/images/hospital.png',
                  text: "Hospitals",
                  gradientColors: [Colors.orange, Colors.white],
                  searchLocation: "Hospitals",
                ),
                _buildServiceBox(
                  image: 'assets/images/busStation.png',
                  text: "Bus Stations",
                  gradientColors: [Colors.yellow, Colors.white],
                  searchLocation: "Bus stations",
                ),
                _buildServiceBox(
                  image: 'assets/images/pharmacies.png',
                  text: "Pharmacies",
                  gradientColors: [Colors.deepPurple, Colors.white],
                  searchLocation: "Pharmacies",
                ),
                _buildServiceBox(
                  image: 'assets/images/temples.png',
                  text: "Religious Centers",
                  gradientColors: [Colors.pinkAccent, Colors.white],
                  searchLocation: "Temples",
                ),
              ],
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
  }) {
    return GestureDetector(
      onTap: () {
        openMap(searchLocation);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 48.0,
              height: 48.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
