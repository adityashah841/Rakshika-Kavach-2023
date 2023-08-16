import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Rakshika/components/app_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnalysisScreenPrevention(),
  ));
}

class AnalysisScreenPrevention extends StatefulWidget {
  const AnalysisScreenPrevention({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalysisScreenPreventionState createState() =>
      _AnalysisScreenPreventionState();
}

class _AnalysisScreenPreventionState extends State<AnalysisScreenPrevention> {
  int selectedChartIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Prevention Diversions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 32),
            _buildLineChart(selectedChartIndex),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChartToggleButton(0, '30 days'),
                const SizedBox(width: 16),
                _buildChartToggleButton(1, '7 Days'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(int chartIndex) {
    List<List<FlSpot>> chartData = [
      [
        const FlSpot(0, 2),
        const FlSpot(1, 3),
        const FlSpot(2, 4),
        const FlSpot(3, 3),
        const FlSpot(4, 5),
        const FlSpot(5, 7),
        const FlSpot(6, 9),
      ],
      [
        const FlSpot(0, 1),
        const FlSpot(1, 2),
        const FlSpot(2, 1.5),
        const FlSpot(3, 2.5),
        const FlSpot(4, 2),
        const FlSpot(5, 3),
        const FlSpot(6, 3.5),
      ],
    ];

    List<Color> chartColors = [Colors.blue, Colors.green];

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true, margin: 10),
            bottomTitles: SideTitles(showTitles: true, margin: 10),
          ),
          gridData: FlGridData(
              show: true, drawVerticalLine: true, drawHorizontalLine: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: chartData[chartIndex],
              isCurved: true,
              colors: [chartColors[chartIndex]],
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              aboveBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartToggleButton(int index, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedChartIndex = index;
        });
      },
      child: Text(label),
    );
  }
}
