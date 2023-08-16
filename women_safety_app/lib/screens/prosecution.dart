import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:Rakshika/components/app_bar.dart';

class AnalysisScreenProsecution extends StatefulWidget {
  const AnalysisScreenProsecution({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalysisScreenProsecutionState createState() =>
      _AnalysisScreenProsecutionState();
}

class _AnalysisScreenProsecutionState extends State<AnalysisScreenProsecution> {
  int _selectedTabIndex = 0;
  int _selectedDurationIndex = 0; // 0 for 7 days, 1 for 30 days

  List<PieChartSectionData> _pieChartData = [];

  List<FlSpot> _graphData = [];

  List<FlSpot> _graphData30Days = [];

  List<FlSpot> get selectedGraphData =>
      _selectedDurationIndex == 0 ? _graphData : _graphData30Days;

  @override
  void initState() {
    super.initState();
    // Initialize sample data
    _initializePieChartData();
    _initializeGraphData();
  }

  void _initializePieChartData() {
    _pieChartData = [
      PieChartSectionData(
        value: 50,
        title: 'Pending',
        color: Colors.blue,
      ),
      PieChartSectionData(
        value: 40,
        title: 'Completed',
        color: Colors.green,
      ),
      PieChartSectionData(
        value: 10,
        title: 'Discarded',
        color: Colors.red,
      ),
    ];
  }

  void _initializeGraphData() {
    _graphData = [
      const FlSpot(1, 20),
      const FlSpot(2, 35),
      const FlSpot(3, 40),
      const FlSpot(4, 55),
      const FlSpot(5, 30),
      const FlSpot(6, 45),
      const FlSpot(7, 50),
    ];

    _graphData30Days = [
      const FlSpot(1, 40),
      const FlSpot(2, 25),
      const FlSpot(3, 30),
      const FlSpot(4, 45),
      const FlSpot(5, 60),
      const FlSpot(6, 35),
      const FlSpot(7, 50),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Center(
                child: PieChart(
                  PieChartData(
                      sections: _pieChartData,
                      startDegreeOffset: -90,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      pieTouchData: PieTouchData()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Pending', 0),
                _buildTabButton('Completed', 1),
                _buildTabButton('Discarded', 2),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationButton('7 Days', 0),
                _buildDurationButton('30 Days', 1),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildGraph(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName, int tabIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10), // Add margin here
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedTabIndex = tabIndex;
            _initializeGraphData(); // Update the graph data based on tab selection
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedTabIndex == tabIndex ? Colors.blue : Colors.grey,
          padding: const EdgeInsets.all(10),
        ),
        child: Text(tabName),
      ),
    );
  }

  Widget _buildDurationButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedDurationIndex = index;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
            color: _selectedDurationIndex == index ? Colors.blue : Colors.grey),
      ),
      child: Text(text),
    );
  }

  Widget _buildGraph() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(showTitles: true),
          leftTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: 70,
        lineBarsData: [
          LineChartBarData(
            spots: selectedGraphData,
            isCurved: true,
            colors: [Colors.blue],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
