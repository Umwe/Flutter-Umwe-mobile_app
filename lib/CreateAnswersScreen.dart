import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AnswersScreen extends StatefulWidget {



  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  String? _selectedOption;

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
              onPressed: () {
                // Add your save logic here
                // For example, you can print the selected options
                print('Option A: ${_optionAController.text}');
                print('Option B: ${_optionBController.text}');
                print('Option C: ${_optionCController.text}');
                print('Option D: ${_optionDController.text}');
                print('Correct Option: $_selectedOption');
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
    home: AnswersScreen(),
  ));
}
