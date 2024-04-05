import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Charts Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: LineChartWidget(
          _createSampleData(), // Call a function to generate sample data
          animate: true,
        ),
      ),
    );
  }

  // Sample data generation function
  List<charts.Series<TimeSeriesSales, int>> _createSampleData() {
    final data = [
      TimeSeriesSales(0, 5),
      TimeSeriesSales(1, 25),
      TimeSeriesSales(2, 100),
      TimeSeriesSales(3, 75),
    ];

    return [
      charts.Series<TimeSeriesSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.year,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

// Sample data model
class TimeSeriesSales {
  final int year;
  final int sales;

  TimeSeriesSales(this.year, this.sales);
}

class LineChartWidget extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  LineChartWidget(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    );
  }
}
