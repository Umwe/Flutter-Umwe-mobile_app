import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Quiz App',
    home: DisplayQuizzesScreen(),
  ));
}

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
    final Uri url = Uri.parse('http://192.168.1.68:8080/quiz/listquiz');
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

  Future<void> deleteQuizConfirmation(BuildContext context, int quizId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this quiz?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteQuiz(quizId); // Proceed with the deletion
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteQuiz(int quizId) async {
    final Uri deleteUrl = Uri.parse('http://192.168.1.68:8080/quiz/delete/$quizId');

    try {
      final response = await http.delete(deleteUrl);

      if (response.statusCode == 204) {
        // If deletion is successful, update the quizzes list to reflect the change
        setState(() {
          quizzes.removeWhere((quiz) => quiz.quizId == quizId);
        });
      } else {
        throw Exception('Failed to delete quiz');
      }
    } catch (e) {
      print('Error deleting quiz: $e');
      // Handle error or show an error message to the user
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.update, color: Colors.blue),
                    onPressed: () {
                      // Add your update logic here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog when delete icon is clicked
                      deleteQuizConfirmation(context, quizzes[index].quizId);
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
