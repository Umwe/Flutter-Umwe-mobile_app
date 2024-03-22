import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




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
            Text('Answer saved successfully!'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to screen to create another question
                  },
                  child: Text('Create Another Question'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to screen to save the quiz
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