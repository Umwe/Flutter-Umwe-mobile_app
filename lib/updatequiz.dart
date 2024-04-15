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
  List<QuizData> quizzes = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    final Uri url = Uri.parse('http://192.168.220.102:8080/quiz/listquiz');
    final response = await http.get(url);

    if (response.statusCode == 200) {
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteQuiz(quizId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteQuiz(int quizId) async {
    final Uri deleteUrl = Uri.parse('http://192.168.220.102:8080/quiz/delete/$quizId');

    try {
      final response = await http.delete(deleteUrl);

      if (response.statusCode == 204) {
        setState(() {
          quizzes.removeWhere((quiz) => quiz.quizId == quizId);
        });
      } else {
        throw Exception('Failed to delete quiz');
      }
    } catch (e) {
      print('Error deleting quiz: $e');
    }
  }

  void navigateToUpdateQuiz(QuizData quizData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateQuizScreen(quizData: quizData),
      ),
    ).then((value) {
      // Refresh the quiz list after returning from the update screen
      fetchQuizzes();
    });
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
                      navigateToUpdateQuiz(quizzes[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
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

class UpdateQuizScreen extends StatefulWidget {
  final QuizData quizData;

  const UpdateQuizScreen({Key? key, required this.quizData}) : super(key: key);

  @override
  _UpdateQuizScreenState createState() => _UpdateQuizScreenState();
}

class _UpdateQuizScreenState extends State<UpdateQuizScreen> {
  late TextEditingController quizNameController;
  late TextEditingController totalMarksController;

  @override
  void initState() {
    super.initState();
    quizNameController = TextEditingController(text: widget.quizData.quizName);
    totalMarksController = TextEditingController(text: widget.quizData.totalMarks.toString());
  }

  @override
  void dispose() {
    quizNameController.dispose();
    totalMarksController.dispose();
    super.dispose();
  }

  void updateQuizData() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayQuizzesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: quizNameController,
              decoration: InputDecoration(labelText: 'Quiz Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: totalMarksController,
              decoration: InputDecoration(labelText: 'Total Marks'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: updateQuizData,
              child: Text('Update Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
