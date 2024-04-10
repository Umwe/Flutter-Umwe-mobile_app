import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'submittedquiz.dart'; // Import the SubmittedQuizScreen

class TakeQuizScreen extends StatefulWidget {
  final int quizId;


  const TakeQuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<Question> questions = []; // Define a list to hold questions
  int currentQuestionIndex = 0; // Track the index of the current question
  int totalMarks = 0; // Track total marks

  @override
  void initState() {
    super.initState();
    fetchQuestions(); // Fetch questions when the screen initializes
  }

  Future<void> fetchQuestions() async {
    final Uri url = Uri.parse('http://192.168.1.65:8080/question/listbyquiz/${widget.quizId}');
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

      // Fetch answers for each question using their IDs
      await fetchAnswersForQuestions();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<void> fetchAnswersForQuestions() async {
    for (var question in questions) {
      final Uri answerUrl = Uri.parse('http://192.168.1.65:8080/answer/listbyquestion/${question.questionId}');
      final answerResponse = await http.get(answerUrl);

      if (answerResponse.statusCode == 200) {
        dynamic answerData = jsonDecode(answerResponse.body);

        if (answerData is List) {
          // Find the answer object corresponding to the current question ID
          var matchingAnswer = answerData.firstWhere((answer) => answer['question']['questionId'] == question.questionId, orElse: () => null);

          if (matchingAnswer != null) {
            // Create an Answer object with all options
            question.answers = [Answer.fromJson(matchingAnswer)];
          } else {
            throw Exception('Answer not found for question ID: ${question.questionId}');
          }
        } else {
          throw Exception('Invalid data format for answers');
        }
      } else {
        throw Exception('Failed to fetch answers for question ID: ${question.questionId}');
      }
    }

    // Set state after fetching all answers
    setState(() {});
  }

  void submitQuiz() {
    int marksObtained = 0;
    for (var question in questions) {
      if (question.selectedAnswer != null) {
        if (question.selectedAnswer == question.answers[0].optionC) {
          marksObtained += question.marks;
        }
      }
    }

    // Navigate to SubmittedQuizScreen and pass the quizId and total marks as parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmittedQuizScreen(
          quizId: widget.quizId, // Pass the quizId to the next screen
          totalMarks: marksObtained,
        ),
      ),
    );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...questions[currentQuestionIndex].answers.map((answer) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      title: Text(answer.optionA),
                      value: answer.optionA,
                      groupValue: questions[currentQuestionIndex].selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          questions[currentQuestionIndex].selectedAnswer = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(answer.optionB),
                      value: answer.optionB,
                      groupValue: questions[currentQuestionIndex].selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          questions[currentQuestionIndex].selectedAnswer = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(answer.optionC),
                      value: answer.optionC,
                      groupValue: questions[currentQuestionIndex].selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          questions[currentQuestionIndex].selectedAnswer = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(answer.optionD),
                      value: answer.optionD,
                      groupValue: questions[currentQuestionIndex].selectedAnswer,
                      onChanged: (value) {
                        setState(() {
                          questions[currentQuestionIndex].selectedAnswer = value.toString();
                        });
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: nextQuestion,
            child: Text(currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'Submit Quiz'),
          ),
          SizedBox(height: 16),
          totalMarks != 0 ? Text('Total Marks: $totalMarks') : Container(),
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
  List<Answer> answers = []; // List to hold answers

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
      options: List<String>.from(json['options'] ?? []),
      marks: json['marks'],
    );
  }
}

class Answer {
  final int answerId;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctOptionIndex;

  Answer({
    required this.answerId,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOptionIndex,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}
