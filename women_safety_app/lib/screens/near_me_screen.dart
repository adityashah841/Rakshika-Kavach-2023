import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';

class NearMeScreen extends StatelessWidget {
  const NearMeScreen({Key? key}) : super(key: key);

  static Future<void> openMap(String location) async {
    // final currentPosition = await Geolocator.getCurrentPosition();
    // final latitude = currentPosition.latitude;
    // final longitude = currentPosition.longitude;
    String googleURL = 'https://www.google.co.in/maps/search/$location';
    // String googleURL = 'https://www.google.co.in/maps/search/$location/@$latitude,$longitude,15z';
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
      backgroundColor: rLightBlue,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Nearby Services",
              style: TextStyle(
                color: Colors.black,
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
                  icon: Icons.local_police,
                  text: "Police Stations",
                  gradientColors: [Colors.lightBlue, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "police stations near me",
                ),
                _buildServiceBox(
                  icon: Icons.train,
                  text: "Railway Stations",
                  gradientColors: [Colors.teal, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "railway stations near me",
                ),
                _buildServiceBox(
                  icon: Icons.local_hospital,
                  text: "Hospitals",
                  gradientColors: [Colors.orange, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "hospitals near me",
                ),
                _buildServiceBox(
                  icon: Icons.directions_bus,
                  text: "Bus Stations",
                  gradientColors: [Colors.yellow, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "bus stations near me",
                ),
                _buildServiceBox(
                  icon: Icons.local_pharmacy_outlined,
                  text: "Pharmacies",
                  gradientColors: [Colors.deepPurple, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "pharmacies near me",
                ),
                _buildServiceBox(
                  icon: Icons.account_balance,
                  text: "Religious Centers",
                  gradientColors: [Colors.pinkAccent, Colors.white],
                  iconColor: Colors.black,
                  searchLocation: "temples near me",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBox({
    required IconData icon,
    required String text,
    required List<Color> gradientColors,
    required Color iconColor,
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
            Icon(
              icon,
              size: 48.0,
              color: iconColor,
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
