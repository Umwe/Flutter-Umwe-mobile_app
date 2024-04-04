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
  int currentQuestionIndex = 0; // Track the index of the current question

  @override
  void initState() {
    super.initState();
    fetchQuestions(); // Fetch questions when the screen initializes
  }

  Future<void> fetchQuestions() async {
    final Uri url = Uri.parse('http://10.152.3.231:8080/question/list/${widget.quizId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body); // Parse as dynamic

      if (data is List) {
        // If data is a list, directly assign it to questions
        setState(() {
          questions = data.map((item) => Question.fromJson(item)).toList();
        });
      } else if (data is Map<String, dynamic> && data.containsKey('questions')) {
        // If data is a map containing 'questions' key with a list of questions
        setState(() {
          questions = List<Question>.from(data['questions'].map((item) => Question.fromJson(item)));
        });
      } else {
        throw Exception('Invalid data format for questions');
      }
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  void submitQuiz() {
    // Implement logic to submit the quiz (calculate score, etc.)
    // You can navigate to a result screen or perform other actions here
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        // Move to the next question if available
        currentQuestionIndex++;
      } else {
        // If all questions are done, submit the quiz
        submitQuiz();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Quiz'),
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching questions
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Question ${currentQuestionIndex + 1}/${questions.length}'), // Display current question number
          SizedBox(height: 16),
          Text(
            'ID: ${questions[currentQuestionIndex].questionId}', // Display question ID
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            questions[currentQuestionIndex].questionText,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ...questions[currentQuestionIndex].options.map((option) {
            return RadioListTile(
              title: Text(option),
              value: option,
              groupValue: questions[currentQuestionIndex].selectedAnswer,
              onChanged: (value) {
                setState(() {
                  questions[currentQuestionIndex].selectedAnswer = value.toString();
                });
              },
            );
          }),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: nextQuestion,
            child: Text(currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'Submit Quiz'),
          ),
        ],
      ),
    );
  }
}

class Question {
  final int questionId;
  final String questionText;
  final List<String> options;
  final int marks;
  String? selectedAnswer; // Track the selected answer

  Question({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.marks,
    this.selectedAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      marks: json['marks'],
    );
  }
}
