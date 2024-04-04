import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_project/user_landing_screen.dart';

class SubmittedQuizScreen extends StatefulWidget {
  final int totalMarks;
  final int quizId;

  const SubmittedQuizScreen({Key? key, required this.totalMarks, required this.quizId}) : super(key: key);

  @override
  _SubmittedQuizScreenState createState() => _SubmittedQuizScreenState();
}

class _SubmittedQuizScreenState extends State<SubmittedQuizScreen> {
  int quizTotalMarks = 0; // Variable to hold quiz total marks

  @override
  void initState() {
    super.initState();
    fetchQuizTotalMarks(); // Fetch quiz total marks when the screen initializes
  }

  Future<void> fetchQuizTotalMarks() async {
    final Uri url = Uri.parse('http://192.168.1.80:8080/quiz/totalMarks/${widget.quizId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final int? data = int.tryParse(response.body); // Parse response body as an integer

      if (data != null) {
        setState(() {
          quizTotalMarks = data; // Set the quiz total marks directly
        });
      } else {
        throw Exception('Invalid response format for total marks');
      }
    } else {
      throw Exception('Failed to fetch quiz total marks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Marks Obtained:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${widget.totalMarks}/$quizTotalMarks', // Display total marks obtained over quiz total marks
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle view answers button press
              },
              child: Text('View Answers'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserLandingScreen()),
                );
              },
              child: Text('Go Back Home'),
            ),

          ],
        ),
      ),
    );
  }
}
