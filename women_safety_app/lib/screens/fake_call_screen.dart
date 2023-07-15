import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';
import 'package:women_safety_app/utils/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      backgroundColor: rDarkBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            _buildFakeCallCard(),
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
                    number: "100",
                  ),
                  _buildServiceCard(
                    name: "Ambulance",
                    description: "Description of the Ambulance service",
                    image: 'assets/images/ambulanceImage.png',
                    number: "102",
                  ),
                  _buildServiceCard(
                    name: "Nirbhaya",
                    description: "Description of the Nirbhaya service",
                    image: 'assets/images/femalePolice.png',
                    number: "1091",
                  ),
                  _buildServiceCard(
                    name: "Help Services",
                    description: "Description of the Help Services",
                    image: 'assets/images/helpImage.png',
                    number: "108",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFakeCallCard() {
    return GestureDetector(
      onTap: () {
        _showCallOptions("Fake Call", "911");
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
              "Description of the Fake Call service",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Call: 911",
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
        _showCallOptions(name, number);
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

  void _showCallOptions(String serviceName, String number) {
    Fluttertoast.showToast(
      msg: "Call $serviceName?",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}