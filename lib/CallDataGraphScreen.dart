import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class CallDataGraphScreen extends StatefulWidget {
  @override
  _CallDataGraphScreenState createState() => _CallDataGraphScreenState();
}

class _CallDataGraphScreenState extends State<CallDataGraphScreen> {
  List<dynamic> callData = [];

  @override
  void initState() {
    super.initState();
    fetchCallData();
  }

  Future<void> fetchCallData() async {
    final response =
    await http.get(Uri.parse('http://your-api-url/api/call-data/all'));

    if (response.statusCode == 200) {
      setState(() {
        callData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Data Graph'),
      ),
      body: Center(
        child: callData.isEmpty
            ? CircularProgressIndicator()
            : buildChart(callData),
      ),
    );
  }

  Widget buildChart(List<dynamic> data) {
    List<String> dates = [];
    List<double> values = [];

    data.forEach((item) {
      dates.add(item['date']);
      values.add(item['total_minutes'].toDouble());
    });

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(dates.length, (index) {
              return FlSpot(index.toDouble(), values[index]);
            }),
          ),
        ],
      ),
    );
  }
}
