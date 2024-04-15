import 'package:flutter/material.dart';
import 'CreateQuestionScreen.dart';
import 'CreateQuizScreen.dart'; // Import the screen where quiz data is entered
import 'DisplayQuizzesScreen.dart'; // Import the screen where quizzes are displayed

class ConfirmationScreen extends StatelessWidget {
  final String quizName;
  final int totalMarks;
  final int quizId;

  ConfirmationScreen({
    required this.quizName,
    required this.totalMarks,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Name: $quizName',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Total Marks: $totalMarks',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to CreateQuestionScreen with quiz data
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuestionScreen(
                      quizName: quizName,
                      totalMarks: totalMarks,
                      quizId: quizId,
                    ),
                  ),
                );
              },
              child: Text('Create another Question'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to DisplayQuizzesScreen to save quiz
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayQuizzesScreen(),
                  ),
                );
              },
              child: Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
