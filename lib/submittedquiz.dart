import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserInfo.dart';
import 'user_landing_screen.dart'; // Import your UserLandingScreen widget
import 'sidebar_menu_user.dart'; // Import your SidebarMenuUser widget

class SubmittedQuizScreen extends StatefulWidget {
  final int totalMarks;
  final int quizId;

  const SubmittedQuizScreen({Key? key, required this.totalMarks, required this.quizId}) : super(key: key);

  @override
  _SubmittedQuizScreenState createState() => _SubmittedQuizScreenState();
}

class _SubmittedQuizScreenState extends State<SubmittedQuizScreen> {
  int quizTotalMarks = 0; // Variable to hold quiz total marks
  late String userId; // Updated to accept userId from UserInfo
  late String username; // Updated to accept username from UserInfo

  @override
  void initState() {
    super.initState();
    // Assign userId and username from UserInfo
    userId = UserInfo().userId ?? '';
    username = UserInfo().username ?? '';
    fetchQuizTotalMarks(); // Fetch quiz total marks when the screen initializes
  }

  Future<void> fetchQuizTotalMarks() async {
    final Uri url = Uri.parse('http://192.168.1.65:8080/quiz/totalMarks/${widget.quizId}');
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

  Future<void> saveMarks() async {
    final Uri saveUrl = Uri.parse('http://192.168.1.65:8080/scoreboards/save');
    final Map<String, dynamic> postData = {
      "quizId": widget.quizId,
      "userId": UserInfo().userId ?? '',
      "totalMarksObtained": '${widget.totalMarks}/$quizTotalMarks',
    };

    final response = await http.post(
      saveUrl,
      body: json.encode(postData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Success message or action after saving to the database
      print('Marks saved successfully!');
    } else {
      // Error handling
      print('Failed to save marks. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Quiz'),
      ),
      drawer: SidebarMenuUser(
        userProfileName: username, // Use username from UserInfo
        userId: userId, // Pass the userId to SidebarMenuUser
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/UserLandingScreen');
        },
        onAboutPressed: () {
          // Handle About press
        },
        onContactPressed: () {
          // Handle Contact press
        },
        onGalleryPressed: () {
          // Handle Gallery press
        },
        onMapPressed: () {
          // Handle Map press
        },
        onSettingsPressed: () {
          // Handle Settings press
        },
        onLogoutPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
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
              onPressed: () async {
                await saveMarks(); // Call the save function when the button is pressed
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
