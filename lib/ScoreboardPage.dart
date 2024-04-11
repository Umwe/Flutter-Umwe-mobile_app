import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScoreboardPage extends StatefulWidget {
  @override
  _ScoreboardPageState createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  Future<List<Map<String, dynamic>>> _fetchScoreboardData() async {
    final response =
    await http.get(Uri.parse('http://10.152.3.231:8080/scoreboards/listall'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch scoreboard data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchScoreboardData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final scoreboardData = snapshot.data!;
            return SingleChildScrollView(
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
                      'Quiz ID',
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
                headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.lightBlue),
                rows: List<DataRow>.generate(
                  scoreboardData.length,
                      (index) {
                    final username = scoreboardData[index]['username'] ?? '';
                    final quizId = scoreboardData[index]['quizId'] ?? '';
                    final quizName = scoreboardData[index]['quizName'] ?? '';
                    final marks = scoreboardData[index]['totalMarksObtained'] ?? '';

                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(username)),
                        DataCell(Text(quizId.toString())),
                        DataCell(Text(quizName)),
                        DataCell(Text(marks.toString())),
                      ],
                    );
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}