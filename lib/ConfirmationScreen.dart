import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Admin_landing_screen.dart'; // Import AdminLandingScreen
import 'CreateQuestionScreen.dart'; // Import CreateQuestionScreen

class ConfirmationScreen extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('Answer saved successfully!'), // Remove or comment out this line
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuestionScreen()),
                    );
                  },
                  child: Text('Create Another Question'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLandingScreen()),
                    );
                  },
                  child: Text('Save Quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
