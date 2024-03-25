import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Quizzes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakeQuizScreen(quizId: 1), // Pass quiz ID here
              ),
            );
          },
          child: Text('Take Quiz'),
        ),
      ),
    );
  }
}

class TakeQuizScreen extends StatefulWidget {
  final int quizId;

  const TakeQuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<Question> questions = []; // Define a list to hold questions

  @override
  void initState() {
    super.initState();
    fetchQuestions(); // Fetch questions when the screen initializes
  }

  Future<void> fetchQuestions() async {
    final Uri url = Uri.parse('http://192.168.62.102:8080/question/list/${widget.quizId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body); // Parse as a Map
      setState(() {
        questions = [Question.fromJson(data)]; // Create a list with a single Question object
      });
    } else {
      throw Exception('Failed to fetch questions');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Quiz'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index].questionText),
            subtitle: Text('Marks: ${questions[index].marks}'),
            // You can display options or handle answers here
          );
        },
      ),
    );
  }
}

class Question {
  final int questionId;
  final String questionText;
  final int marks;

  Question({required this.questionId, required this.questionText, required this.marks});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionText: json['questionText'],
      marks: json['marks'],
    );
  }
}

