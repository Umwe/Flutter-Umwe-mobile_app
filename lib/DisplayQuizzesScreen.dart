import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayQuizzesScreen extends StatefulWidget {
  @override
  _DisplayQuizzesScreenState createState() => _DisplayQuizzesScreenState();
}

class _DisplayQuizzesScreenState extends State<DisplayQuizzesScreen> {
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
      throw Exception('Failed to fetch quizzes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Quizzes'),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.lightBlueAccent, // Set background color here
            child: ListTile(
              title: Text('${quizzes[index].quizName} / ${quizzes[index].totalMarks}'),
            ),
          );
        },
      ),
    );
  }
}

class QuizData {
  final String quizName;
  final int totalMarks;

  QuizData({required this.quizName, required this.totalMarks});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      quizName: json['quizName'],
      totalMarks: json['totalMarks'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Quiz App',
    home: DisplayQuizzesScreen(),
  ));
}
