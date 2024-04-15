import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart'; // Import the services.dart package
import 'package:mobile_app_project/UserInfo.dart'; // Import UserInfo class
import 'sidebar_menu.dart'; // Import SidebarMenu

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
      final response = await http.get(Uri.parse('http://192.168.220.102:8080/calldata/listall'));
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

  Future<void> refreshData() async {
    setState(() {
      graphData.clear();
    });
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Data Graphs'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshData,
          ),
        ],
      ),
      drawer: SidebarMenu(
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/adminLandingScreen');
        },
        onAboutPressed: () {
          // Implement the functionality for the About button here
        },
        onContactPressed: () {
          // Implement the functionality for the Contact button here
        },
        onGalleryPressed: () {
          // Implement the functionality for the Gallery button here
        },
        onMapPressed: () {
          // Implement the functionality for the Map button here
        },
        onSettingsPressed: () {
          // Implement the functionality for the Settings button here
        },
        onLogoutPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        onSystemGraphPressed: () {
          // Implement the functionality for the System Graph button here
        },
        onSharedDataGraphPressed: () {
          Navigator.pushReplacementNamed(context, '/CallDataGraphScreen');
          // Implement the functionality for the Shared Data Graph button here
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GraphWidget(
              title: 'Pie Chart',
              graphData: graphData,
              is3DPieChart: true,
            ),
            GraphWidget(
              title: 'Pareto Chart',
              graphData: graphData,
              is3DPieChart: false,
              isParetoChart: true, // Set this flag for Pareto chart
            ),
            GraphWidget(
              title: '3D Clustered Column Chart',
              graphData: graphData,
              is3DClusteredColumn: true, // Set this flag for 3D clustered column chart
            ),
            GraphWidget(title: 'Other Graph 3',
                graphData: [],
                is3DPieChart: false),
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
  final bool isParetoChart;
  final bool is3DClusteredColumn; // New flag for 3D clustered column chart

  const GraphWidget({
    Key? key,
    required this.title,
    required this.graphData,
    this.is3DPieChart = false,
    this.isParetoChart = false,
    this.is3DClusteredColumn = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.425,
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
                child: graphData.isEmpty
                    ? Text(
                  'No data available',
                  style: TextStyle(fontSize: 18),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (is3DPieChart)
                      Container(
                        height: 380,
                        width: 550,
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
                                      radius: 150, // Adjust the radius to make the pie larger
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  centerSpaceRadius:
                                  0, // Set this to 0 for a 3D effect without inner free color
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
                    if (isParetoChart)
                      Container(
                        height: 350,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(),
                          series: <ChartSeries<CallData, String>>[
                            ColumnSeries<CallData, String>(
                              dataSource: graphData,
                              xValueMapper: (CallData data, _) => data.date,
                              yValueMapper: (CallData data, _) => data.totalCost,
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<CallData, String>(
                              dataSource: graphData,
                              xValueMapper: (CallData data, _) => data.date,
                              yValueMapper: (CallData data, _) => data.totalCost,
                            ),
                          ],
                        ),
                      ),
                    if (is3DClusteredColumn)
                      Container(
                        height: 350,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(),
                          series: <ChartSeries<CallData, String>>[
                            ColumnSeries<CallData, String>(
                              dataSource: graphData,
                              xValueMapper: (CallData data, _) => data.date,
                              yValueMapper: (CallData data, _) => data.totalCost,
                            ),
                          ],
                          plotAreaBorderWidth: 0,
                          enableMultiSelection: false,
                          isTransposed: true,
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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MaterialApp(
      home: CallDataGraphScreen(),
    ));
  });
}
