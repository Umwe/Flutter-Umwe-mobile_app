import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CallData {
  final String date;
  final int numberOfCalls;
  final int totalMinutes;
  final double totalCost;

  CallData({
    required this.date,
    required this.numberOfCalls,
    required this.totalMinutes,
    required this.totalCost,
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
              graphData: [
                CallData(date: '2024-04-01', numberOfCalls: 100, totalMinutes: 200, totalCost: 50.0),
                CallData(date: '2024-04-02', numberOfCalls: 150, totalMinutes: 300, totalCost: 70.0),
                CallData(date: '2024-04-03', numberOfCalls: 120, totalMinutes: 250, totalCost: 60.0),
                CallData(date: '2024-04-04', numberOfCalls: 90, totalMinutes: 180, totalCost: 40.0),
                CallData(date: '2024-04-05', numberOfCalls: 80, totalMinutes: 160, totalCost: 35.0),
              ],
              is3DPieChart: true,
            ),
            GraphWidget(graphData: [], is3DPieChart: false), // Placeholder for other graphs
            GraphWidget(graphData: [], is3DPieChart: false), // Placeholder for other graphs
            GraphWidget(graphData: [], is3DPieChart: false), // Placeholder for other graphs
          ],
        ),
      ),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final List<CallData> graphData;
  final bool is3DPieChart;

  const GraphWidget({Key? key, required this.graphData, this.is3DPieChart = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40, // Adjust this height as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (is3DPieChart && graphData.isNotEmpty)
                Container(
                  height: 200,
                  width: 200,
                  child: PieChart3D(
                    dataMap: {
                      for (var data in graphData)
                        data.date: data.totalCost,
                    },
                    chartRadius: 100,
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    ringStrokeWidth: 32,
                    centerText: "Costs",
                    legendOptions: LegendOptions(showLegends: true),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CallDataGraphScreen(),
  ));
}
