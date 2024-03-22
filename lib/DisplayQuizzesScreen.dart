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

  Future<void> deleteQuiz(int quizId) async {
    // Replace the URL with your API endpoint to delete a quiz
    final Uri url = Uri.parse('http://10.152.3.231:8080/quiz/delete/$quizId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Quiz deleted successfully, update UI or show a message
      setState(() {
        quizzes.removeWhere((quiz) => quiz.quizId == quizId);
      });
    } else {
      throw Exception('Failed to delete quiz');
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
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8), // Add space between rows
        itemBuilder: (context, index) {
          return Container(
            color: Colors.lightBlueAccent, // Set background color here
            child: ListTile(
              title: Text(
                '${quizzes[index].quizName} / ${quizzes[index].totalMarks}',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text('ID: ${quizzes[index].quizId}', style: TextStyle(fontSize: 12)), // Display quizId as subtitle
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.update, color: Colors.green),
                    onPressed: () {
                      // Add your update logic here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show delete confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete "${quizzes[index].quizName}"?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Call delete function
                                  deleteQuiz(quizzes[index].quizId);
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
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

void main() {
  runApp(MaterialApp(
    title: 'Quiz App',
    home: DisplayQuizzesScreen(),
  ));
}
