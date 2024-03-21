import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CreateAnswersScreen.dart';

class CreateQuestionScreen extends StatefulWidget {
  final String quizName;
  final int totalMarks;
  final int quizId;

  CreateQuestionScreen({
    required this.quizName,
    required this.totalMarks,
    required this.quizId,
  });

  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  String? _selectedOption;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _marksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Question for ${widget.quizName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _marksController,
              decoration: InputDecoration(labelText: 'Marks'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                await saveQuestion();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswersScreen(

                    ),
                  ),
                );
              },
              child: Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveQuestion() async {
    try {
      Map<String, dynamic> questionData = {
        'questionText': _questionController.text,
        'marks': int.parse(_marksController.text),
        'quiz': {
          'quizId': widget.quizId,
        },
      };

      final response = await http.post(
        Uri.parse('http://10.152.3.231:8080/question/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(questionData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        int questionId = responseData['questionId'];
        print('Generated Question ID: $questionId');
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: Invalid data sent to the server.');
      } else {
        throw Exception('Failed to save question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving question: $e');
      throw Exception('Failed to save question: $e');
    }
  }

}

