import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CallData {
  final String date;
  final int numberOfCalls;
  final int totalMinutes;
  final double totalCost;
  final Color color; // New field to store color for each data point

  CallData({
    required this.date,
    required this.numberOfCalls,
    required this.totalMinutes,
    required this.totalCost,
    required this.color, // Color parameter added
  });
}

class CallDataGraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Data Graphs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GraphWidget(
              title: 'Pie Chart', // Title for the pie chart grid
              graphData: [
                CallData(date: '2024-04-01', numberOfCalls: 100, totalMinutes: 200, totalCost: 50.0, color: Colors.blue),
                CallData(date: '2024-04-02', numberOfCalls: 150, totalMinutes: 300, totalCost: 70.0, color: Colors.green),
                CallData(date: '2024-04-03', numberOfCalls: 120, totalMinutes: 250, totalCost: 60.0, color: Colors.red),
                CallData(date: '2024-04-04', numberOfCalls: 90, totalMinutes: 180, totalCost: 40.0, color: Colors.orange),
                CallData(date: '2024-04-05', numberOfCalls: 80, totalMinutes: 160, totalCost: 35.0, color: Colors.purple),
              ],
              is3DPieChart: true,
            ),
            GraphWidget(title: 'Other Graph 1', graphData: [], is3DPieChart: false),
            GraphWidget(title: 'Other Graph 2', graphData: [], is3DPieChart: false),
            GraphWidget(title: 'Other Graph 3', graphData: [], is3DPieChart: false),
          ],
        ),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final String title;
  final List<CallData> graphData;
  final bool is3DPieChart;

  const GraphWidget({Key? key, required this.title, required this.graphData, this.is3DPieChart = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40, // Adjust this height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    if (is3DPieChart && graphData.isNotEmpty)
                      Container(
                        height: 200,
                        width: 200,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(
                              graphData.length,
                                  (index) => PieChartSectionData(
                                color: graphData[index].color,
                                value: graphData[index].totalCost,
                                title: '', // No need to show title (dates) on segments
                                radius: 80, // Adjust the radius to make the pie larger
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 0, // Set this to 0 for a 3D effect without inner free color
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: graphData.map((data) {
                            return Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: data.color,
                                ),
                                SizedBox(width: 4),
                                Text('${data.date}', style: TextStyle(fontSize: 12)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
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
}

void main() {
  runApp(MaterialApp(
    home: CallDataGraphScreen(),
  ));
}
