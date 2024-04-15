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
    final Uri url = Uri.parse('http://192.168.220.102:8080/quiz/listquiz');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse JSON response into a list of QuizData objects
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        quizzes = data.map((item) => QuizData.fromJson(item)).toList();
      });
      // Fetch total questions for each quiz
      for (int i = 0; i < quizzes.length; i++) {
        await fetchTotalQuestions(quizzes[i].quizId, i);
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch quizzes');
    }
  }

  Future<void> fetchTotalQuestions(int quizId, int index) async {
    final Uri url = Uri.parse('http://192.168.220.102:8080/quiz/totalQuestions/$quizId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      int totalQuestions = int.parse(response.body);
      setState(() {
        quizzes[index].totalQuestions = totalQuestions;
      });
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to fetch total questions for quiz $quizId');
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${quizzes[index].quizId}', style: TextStyle(fontSize: 12)),
                  Text('Total Questions: ${quizzes[index].totalQuestions}', style: TextStyle(fontSize: 12)),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle button press here
                  // Navigate to TakeQuizScreen with quiz ID and name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeQuizScreen(
                        quizId: quizzes[index].quizId,
                        quizName: quizzes[index].quizName,
                      ),
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
  int totalQuestions; // Updated to include totalQuestions field

  QuizData({required this.quizId, required this.quizName, required this.totalMarks, this.totalQuestions = 0});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      quizId: json['quizId'],
      quizName: json['quizName'],
      totalMarks: json['totalMarks'],
      totalQuestions: 0, // Initialize totalQuestions field
    );
  }
}
