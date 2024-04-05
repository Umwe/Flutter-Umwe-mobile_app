import 'package:flutter/material.dart';

class ScoreboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skyBlueColor = MaterialColor(
      0xFF87CEFA,
      <int, Color>{
        50: Color(0xFFE1F5FE),
        100: Color(0xFFB3E5FC),
        200: Color(0xFF81D4FA),
        300: Color(0xFF4FC3F7),
        400: Color(0xFF29B6F6),
        500: Color(0xFF03A9F4),
        600: Color(0xFF039BE5),
        700: Color(0xFF0288D1),
        800: Color(0xFF0277BD),
        900: Color(0xFF01579B),
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'No.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Quiz Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Marks Obtained',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          headingRowColor: MaterialStateColor.resolveWith((states) => skyBlueColor),
          rows: [
            DataRow(
              cells: [
                DataCell(Text('1')),
                DataCell(Text('John')),
                DataCell(Text('Flutter Quiz')),
                DataCell(Text('95')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('2')),
                DataCell(Text('Jane')),
                DataCell(Text('Dart Quiz')),
                DataCell(Text('85')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('3')),
                DataCell(Text('Mike')),
                DataCell(Text('UI Design Quiz')),
                DataCell(Text('90')),
              ],
            ),
            // Add more rows as needed
          ],
        ),
      ),
    );
  }
}