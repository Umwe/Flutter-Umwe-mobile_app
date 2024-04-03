import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'TakeQuizScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Quiz App',
    home: DisplayQuizForUser(),
  ));
}

class DisplayQuizForUser extends StatefulWidget {
  @override
  _DisplayQuizForUserState createState() => _DisplayQuizForUserState();
}

class _DisplayQuizForUserState extends State<DisplayQuizForUser> {
  List<QuizData> quizzes = []; // Define a list to hold quiz data

  @override
  void initState() {
    super.initState();
    fetchQuizzes(); // Fetch quizzes when the screen initializes
  }

  Future<void> fetchQuizzes() async {
    // Replace the URL with your API endpoint to fetch quizzes
    final Uri url = Uri.parse('http://10.152.3.231:8080/quiz/listquiz');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse JSON response into a list of QuizData objects
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        quizzes = data.map((item) => QuizData.fromJson(item)).toList();
      });
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch quizzes');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Quizzes'),
      ),
      body: ListView.separated(
        itemCount: quizzes.length,
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.lightBlueAccent,
            child: ListTile(
              title: Text(
                '${quizzes[index].quizName} / ${quizzes[index].totalMarks}',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text('ID: ${quizzes[index].quizId}', style: TextStyle(fontSize: 12)),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle button press here
                  // Navigate to TakeQuizScreen with quiz ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeQuizScreen(quizId: quizzes[index].quizId),
                    ),
                  );
                },
                child: Text('Take Quiz'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizData {
  final int quizId;
  final String quizName;
  final int totalMarks;

  QuizData({required this.quizId, required this.quizName, required this.totalMarks});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      quizId: json['quizId'],
      quizName: json['quizName'],
      totalMarks: json['totalMarks'],
    );
  }
}
