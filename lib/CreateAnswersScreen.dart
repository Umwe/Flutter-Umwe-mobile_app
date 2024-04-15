import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ConfirmationScreen.dart';

class AnswersScreen extends StatefulWidget {
  final int questionId; // Field to store the question ID
  final String quizName; // Field to store the quiz name
  final int totalMarks; // Field to store the total marks
  final int quizId; // Field to store the quiz ID

  AnswersScreen({
    required this.questionId,
    required this.quizName,
    required this.totalMarks,
    required this.quizId,
  }); // Constructor to accept these fields

  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  int? _selectedOptionIndex;

  int _getCorrectOptionIndex() {
    return _selectedOptionIndex ?? -1; // Default to -1 if no option is selected
  }

  Future<void> _saveAnswer() async {
    // Prepare the data to send in the POST request
    Map<String, dynamic> postData = {
      'question': {
        'questionId': widget.questionId,
      },
      'optionA': _optionAController.text,
      'optionB': _optionBController.text,
      'optionC': _optionCController.text,
      'optionD': _optionDController.text,
      'correctOptionIndex': _getCorrectOptionIndex(),
      'quizName': widget.quizName, // Include quizName in the post data
      'totalMarks': widget.totalMarks, // Include totalMarks in the post data
      'quizId': widget.quizId, // Include quizId in the post data
    };

    // Send the HTTP POST request
    try {
      final response = await http.post(
        Uri.parse('http://192.168.220.102:8080/answer/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 201) {
        print('Answer saved successfully.');
        // Handle success as needed, such as showing a success message or navigating to another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              quizName: widget.quizName,
              totalMarks: widget.totalMarks,
              quizId: widget.quizId,
            ),
          ),
        );
      } else {
        print('Failed to save answer: ${response.statusCode}');
        // Handle error, such as showing an error message to the user
      }
    } catch (e) {
      print('Error saving answer: $e');
      // Handle error, such as showing an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answers Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SizedBox(height: 16),
            Text('Choose Correct Answer:'),
            RadioListTile<int>(
              title: Text('Option A'),
              value: 0,
              groupValue: _selectedOptionIndex,
              onChanged: (int? value) {
                setState(() {
                  _selectedOptionIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option B'),
              value: 1,
              groupValue: _selectedOptionIndex,
              onChanged: (int? value) {
                setState(() {
                  _selectedOptionIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option C'),
              value: 2,
              groupValue: _selectedOptionIndex,
              onChanged: (int? value) {
                setState(() {
                  _selectedOptionIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option D'),
              value: 3,
              groupValue: _selectedOptionIndex,
              onChanged: (int? value) {
                setState(() {
                  _selectedOptionIndex = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveAnswer,
              child: Text('Save Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
