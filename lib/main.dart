import 'package:flutter/material.dart';
import 'package:mobile_app_project/step_counter.dart';
import 'package:mobile_app_project/updatequiz.dart';
import 'package:mobile_app_project/user_landing_screen.dart';
import 'CallDataGraphScreen.dart';
import 'DisplayQuizForUser.dart';
import 'LoginPage.dart';
import 'MapPage.dart';
import 'admin_landing_screen.dart';
import 'SavedAnswersScreen.dart';
import 'compass_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => LoginPage(), // Define LoginPage as the initial route
        '/UserLandingScreen': (context) => UserLandingScreen(), // User Landing Screen route
        '/adminLandingScreen': (context) => AdminLandingScreen(), // Admin Landing Screen route
        '/displayQuizForUser': (context) => DisplayQuizForUser(), // Display Quiz For User route
        '/savedAnswersScreen': (context) => SavedAnswersScreen(), // Saved Answers Screen route
        '/CallDataGraphScreen': (context) => CallDataGraphScreen(), //  graph pages

      },
    );
  }
}
