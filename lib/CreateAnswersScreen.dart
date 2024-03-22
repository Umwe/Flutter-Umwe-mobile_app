import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnswersScreen extends StatefulWidget {
  final int questionId; // Add a field to store the question ID

  AnswersScreen({required this.questionId}); // Constructor to accept question ID

  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  String? _selectedOption;

  int _getCorrectOptionIndex() {
    switch (_selectedOption) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return -1; // Invalid index, handle this case accordingly
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Prepare the data to send in the POST request
                Map<String, dynamic> postData = {
                  'question': widget.questionId,
                  'optionA': _optionAController.text,
                  'optionB': _optionBController.text,
                  'optionC': _optionCController.text,
                  'optionD': _optionDController.text,
                  'correctOptionIndex': _getCorrectOptionIndex(),
                };

                // Send the HTTP POST request
                try {
                  final response = await http.post(
                    Uri.parse('http://localhost:8080/answer/save'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(postData),
                  );

                  if (response.statusCode == 201) {
                    print('Answer saved successfully.');
                    // Handle success as needed, such as showing a success message or navigating to another screen
                  } else {
                    print('Failed to save answer: ${response.statusCode}');
                    // Handle error, such as showing an error message to the user
                  }
                } catch (e) {
                  print('Error saving answer: $e');
                  // Handle error, such as showing an error message to the user
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnswersScreen(questionId: 123), // Pass the question ID here
  ));
}
