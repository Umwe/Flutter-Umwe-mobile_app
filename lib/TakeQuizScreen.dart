import 'package:flutter/material.dart';
class TakeQuizScreen extends StatefulWidget {
  final List<QuestionData> questions; // Corrected parameter type

  const TakeQuizScreen(this.questions);

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int currentIndex = 0; // Index of the current question
  List<int?> selectedAnswers = []; // Store user's selected answers

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(widget.questions.length, null); // Initialize selectedAnswers list
  }

  void answerQuestion(int selectedOptionIndex) {
    selectedAnswers[currentIndex] = selectedOptionIndex;
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // All questions answered, show submission dialog or navigate to result screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submit Quiz'),
            content: Text('Are you sure you want to submit the quiz?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Handle submission logic, e.g., calculate score and navigate to result screen
                },
                child: Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentIndex + 1} of ${widget.questions.length}:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.questions[currentIndex].questionText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                widget.questions[currentIndex].options.length,
                    (index) => ElevatedButton(
                  onPressed: () {
                    answerQuestion(index);
                  },
                  child: Text(widget.questions[currentIndex].options[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionData {
  final int questionId;
  final String questionText;
  final List<String> options;

  QuestionData({required this.questionId, required this.questionText, required this.options});
}
