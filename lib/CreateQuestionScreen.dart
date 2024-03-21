import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  TextEditingController _optionAController = TextEditingController();
  TextEditingController _optionBController = TextEditingController();
  TextEditingController _optionCController = TextEditingController();
  TextEditingController _optionDController = TextEditingController();

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
            TextField(
              controller: _optionAController,
              decoration: InputDecoration(labelText: 'Option A'),
            ),
            TextField(
              controller: _optionBController,
              decoration: InputDecoration(labelText: 'Option B'),
            ),
            TextField(
              controller: _optionCController,
              decoration: InputDecoration(labelText: 'Option C'),
            ),
            TextField(
              controller: _optionDController,
              decoration: InputDecoration(labelText: 'Option D'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedOption,
              items: ['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Correct Option'),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveQuestionAndAnswer();
              },
              child: Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> saveQuestion(
      Map<String, dynamic> questionData) async {
    final response = await http.post(
      Uri.parse('http://10.152.3.231:8080/question/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(questionData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save question');
    }
  }

  Future<void> saveAnswer(Map<String, dynamic> answerData) async {
    await http.post(
      Uri.parse('http://10.152.3.231:8080/answer/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(answerData),
    );
  }

  void clearFields() {
    _questionController.clear();
    _marksController.clear();
    _optionAController.clear();
    _optionBController.clear();
    _optionCController.clear();
    _optionDController.clear();
    _selectedOption = null;
  }

  Future<void> saveQuestionAndAnswer() async {
    if (widget.quizId != null && _selectedOption != null) {
      String questionText = _questionController.text;
      String marksText = _marksController.text.trim();
      if (questionText.isNotEmpty && marksText.isNotEmpty) {
        int marks = int.parse(marksText);
        Map<String, dynamic> questionData = {
          'quizId': widget.quizId,
          'questionText': questionText,
          'marks': marks,
        };

        try {
          // Send question data to backend
          final questionResponse = await saveQuestion(questionData);
          int questionId = questionResponse['questionId'];

          // Save answer data
          Map<String, dynamic> answerData = {
            'questionId': questionId,
            'optionA': _optionAController.text,
            'optionB': _optionBController.text,
            'optionC': _optionCController.text,
            'optionD': _optionDController.text,
            'correctOptionIndex': ['A', 'B', 'C', 'D'].indexOf(
                _selectedOption!),
          };

          try {
            // Send answer data to backend
            await saveAnswer(answerData);

            // Show success message and clear fields
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Question and Answer saved successfully')),
            );
            clearFields(); // Clear all fields after successful save
          } catch (e) {
            // Handle error saving answer
            print('Error saving answer: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving answer. Please try again.')),
            );
          }
        } catch (e) {
          // Handle error saving question
          print('Error saving question: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving question. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields.')),
        );
      }
    } else {
      // Handle null quizId or invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid quiz ID or selected option.')),
      );
    }
  }
}

