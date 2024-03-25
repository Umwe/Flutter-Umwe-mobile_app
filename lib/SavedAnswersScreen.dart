import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavedAnswersScreen extends StatefulWidget {
  @override
  _SavedAnswersScreenState createState() => _SavedAnswersScreenState();
}

class _SavedAnswersScreenState extends State<SavedAnswersScreen> {
  List<Answer> savedAnswers = []; // List to hold saved answers

  @override
  void initState() {
    super.initState();
    fetchSavedAnswers(); // Fetch saved answers when the screen initializes
  }

  Future<void> fetchSavedAnswers() async {
    final Uri url = Uri.parse('http://192.168.62.102:8080/answer/listall');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body); // Parse as a list of dynamic
      setState(() {
        savedAnswers = data.map((item) => Answer.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to fetch saved answers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Answers'),
      ),
      body: ListView.builder(
        itemCount: savedAnswers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Question ID: ${savedAnswers[index].question.questionId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Option A: ${savedAnswers[index].optionA}'),
                Text('Option B: ${savedAnswers[index].optionB}'),
                Text('Option C: ${savedAnswers[index].optionC}'),
                Text('Option D: ${savedAnswers[index].optionD}'),
                Text('Correct Option Index: ${savedAnswers[index].correctOptionIndex}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Answer {
  final int answerId;
  final Question question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctOptionIndex;

  Answer({
    required this.answerId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOptionIndex,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      question: Question.fromJson(json['question']),
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}

class Question {
  final int questionId;

  Question({required this.questionId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
    );
  }
}
