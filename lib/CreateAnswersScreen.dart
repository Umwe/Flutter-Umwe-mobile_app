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
              itemCount: questions.length + 1, // +1 for the "Add Question" button
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  // Add Question button
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        questions.add({
                          'question': '',
                          'options': ['', '', '', ''],
                          'correctAnswer': 0,
                        });
                      });
                    },
                    child: Text('Add Question'),
                  );
                }
                return buildQuestionWidget(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionWidget(int index) {
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
          for (int i = 0; i < 4; i++)
            TextField(
              decoration: InputDecoration(labelText: 'Option ${i + 1}'),
              onChanged: (value) {
                questions[index]['options'][i] = value;
              },
            ),
          DropdownButtonFormField(
            value: questions[index]['correctAnswer'],
            items: [
              for (int i = 0; i < 4; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text('Option ${i + 1}'),
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
  }
}
