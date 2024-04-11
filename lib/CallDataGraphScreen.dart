import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class CallDataGraphScreen extends StatefulWidget {
  @override
  _CallDataGraphScreenState createState() => _CallDataGraphScreenState();
}

class _CallDataGraphScreenState extends State<CallDataGraphScreen> {
  List<CallData> graphData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.152.3.231:8080/calldata/listall'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print('Fetched data: $responseData');
        setState(() {
          graphData = responseData
              .map((data) => CallData(
            date: data['date'],
            numberOfCalls: data['numberOfCalls'],
            totalMinutes: data['totalMinutes'],
            totalCost: data['totalCost'].toDouble(),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          ))
              .toList();
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


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
              graphData: graphData,
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

  const GraphWidget({Key? key, required this.title, required this.graphData, this.is3DPieChart = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.425, // Adjust this height as needed
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (is3DPieChart && graphData.isNotEmpty)
                      Container(
                        height: 350,
                        width: 450,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: PieChart(
                                PieChartData(
                                  sections: List.generate(
                                    graphData.length,
                                        (index) => PieChartSectionData(
                                      color: graphData[index].color,
                                      value: graphData[index].totalCost,
                                      title: '', // No need to show title (dates) on segments
                                      radius: 140, // Adjust the radius to make the pie larger
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
                                width: 400,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    graphData.length,
                                        (index) => Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: graphData[index].color,
                                          ),
                                          SizedBox(width: 4),
                                          Text('${graphData[index].date}', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!is3DPieChart || graphData.isEmpty)
                      Text(
                        'No data available',
                        style: TextStyle(fontSize: 18),
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
