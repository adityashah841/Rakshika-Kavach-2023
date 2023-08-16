import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import 'package:Rakshika/components/app_bar.dart';

class AnalysisScreenPre extends StatelessWidget {
  const AnalysisScreenPre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AnalysisBox(
                    label: 'Women Saved',
                    number: 123,
                    improvement: 15,
                  ),
                  _AnalysisBox(
                    label: 'Crime Reduce',
                    number: 456,
                    improvement: -7,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'No. of User v/s Days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              _BarChart(),
              const SizedBox(height: 16),
              _SecondBarChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisBox extends StatelessWidget {
  final String label;
  final int number;
  final int improvement;

  const _AnalysisBox({
    required this.label,
    required this.number,
    required this.improvement,
  });

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.40;
    return Container(
      width: boxWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            number.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                improvement >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: improvement >= 0 ? Colors.green : Colors.red,
              ),
              Text(
                '$improvement%',
                style: TextStyle(
                  color: improvement >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomData = List.generate(7, (index) => random.nextInt(20) + 5);

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 16,
              getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'PreC';
                  case 1:
                    return 'PreV';
                  case 2:
                    return 'PreS';
                  case 3:
                    return 'Users';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: true),
          ),
          borderData: FlBorderData(
              show: false, border: const Border(bottom: BorderSide.none)),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  y: randomData[2].toDouble(), colors: [Colors.blue]),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  y: randomData[5].toDouble(), colors: [Colors.blue]),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(
                  y: randomData[1].toDouble(), colors: [Colors.blue]),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(
                  y: randomData[5].toDouble(), colors: [Colors.blue]),
            ]),
            // ... Add more day data
          ],
        ),
      ),
    );
  }
}

class _SecondBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final increasingData = [15, 20, 25, 30, 35, 40, 45];

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 16,
              getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'S';
                  case 1:
                    return 'M';
                  case 2:
                    return 'T';
                  case 3:
                    return 'W';
                  case 4:
                    return 'Th';
                  case 5:
                    return 'F';
                  // ... Add more day labels
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: true),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  y: increasingData[0].toDouble(), colors: [Colors.green]),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  y: increasingData[1].toDouble(), colors: [Colors.green]),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(
                  y: increasingData[2].toDouble(), colors: [Colors.green]),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(
                  y: increasingData[3].toDouble(), colors: [Colors.green]),
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(
                  y: increasingData[4].toDouble(), colors: [Colors.green]),
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(
                  y: increasingData[5].toDouble(), colors: [Colors.green]),
            ]),
            // ... Add more day data
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnalysisScreenPre(),
  ));
}
