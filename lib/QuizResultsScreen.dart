import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_project/sidebar_menu_user.dart';
import 'package:mobile_app_project/UserInfo.dart';

class QuizResultsScreen extends StatefulWidget {
  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  final UserInfo userInfo = UserInfo();

  List<Map<String, dynamic>> quizResults = [];

  Future<void> fetchQuizResults() async {
    try {
      String userId = userInfo.userId ?? '';
      if (userId.isNotEmpty) {
        final response = await http.get(Uri.parse('http://10.152.3.231:8080/scoreboards/listbyuser/$userId'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            quizResults = List<Map<String, dynamic>>.from(data);
          });
        } else {
          throw Exception('Failed to load quiz results');
        }
      }
    } catch (e) {
      print('Error fetching quiz results: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuizResults();
  }

  @override
  Widget build(BuildContext context) {
    String userProfileName = userInfo.username ?? 'Full Name';
    String userEmail = userInfo.email ?? 'Email';
    String userId = userInfo.userId ?? 'User ID';

    int counter = 1; // Initialize the counter

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      drawer: SidebarMenuUser(
        userProfileName: userProfileName,
        userEmail: userEmail,
        userId: userId,
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/UserLandingScreen');
        },
        onAboutPressed: () {
          // Handle About pressed
        },
        onContactPressed: () {
          // Handle Contact pressed
        },
        onGalleryPressed: () {
          // Handle Gallery pressed
        },
        onMapPressed: () {
          // Handle Map pressed
        },
        onSettingsPressed: () {
          // Handle Settings pressed
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
              'Results for $userProfileName',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Quiz ID')),
                    DataColumn(label: Text('Quiz Name')),
                    DataColumn(label: Text('Total Marks Obtained')),
                  ],
                  rows: quizResults
                      .map(
                        (result) {
                      // Use the counter and increment after each row
                      final currentCounter = counter++;
                      return DataRow(cells: [
                        DataCell(Text(currentCounter.toString())),
                        DataCell(Text(result['quizId']?.toString() ?? '')),
                        DataCell(Text(result['quizName']?.toString() ?? '')),
                        DataCell(Text(result['totalMarksObtained']?.toString() ?? '')),
                      ]);
                    },
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
