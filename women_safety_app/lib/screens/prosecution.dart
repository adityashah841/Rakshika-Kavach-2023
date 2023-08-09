import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';

class AnalysisScreenProsecution extends StatelessWidget {
  const AnalysisScreenProsecution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Prosecution Statistics",
              style: TextStyle(
                color: Color.fromARGB(255, 8, 0, 123),
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 13),
              width: MediaQuery.of(context).size.width * 0.9,
              // height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset('assets/images/RiskMatrixChart.jpg'),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              // height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Image.asset('assets/images/hello.png'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnalysisScreenProsecution(),
  ));
}
