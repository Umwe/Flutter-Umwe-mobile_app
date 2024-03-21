import 'package:flutter/material.dart';

class AnswersScreen extends StatefulWidget {
  final String quizName;
  final int quizId;

  AnswersScreen({
    required this.quizName,
    required this.quizId,
  });

  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  List<Map<String, dynamic>> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answers for ${widget.quizName}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Question ${index + 1}'),
                      TextField(
                        decoration: InputDecoration(labelText: 'Question'),
                        onChanged: (value) {
                          questions[index]['question'] = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Option 1'),
                        onChanged: (value) {
                          questions[index]['options'][0] = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Option 2'),
                        onChanged: (value) {
                          questions[index]['options'][1] = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Option 3'),
                        onChanged: (value) {
                          questions[index]['options'][2] = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Option 4'),
                        onChanged: (value) {
                          questions[index]['options'][3] = value;
                        },
                      ),
                      DropdownButtonFormField(
                        value: questions[index]['correctAnswer'],
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Option 1'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Option 2'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Option 3'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Option 4'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            questions[index]['correctAnswer'] = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Correct Answer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                questions.add({
                  'question': '',
                  'options': ['', '', '', ''],
                  'correctAnswer': 0,
                });
              });
            },
            child: Text('Save Answer'),
          ),
        ],
      ),
    );
  }
}
