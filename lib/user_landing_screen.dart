import 'package:flutter/material.dart';
import 'UserInfo.dart'; // Import the UserInfo class from your app
import 'sidebar_menu_user.dart';
import 'DisplayQuizForUser.dart';
import 'QuizResultsScreen.dart';

class UserLandingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String username = UserInfo().username ?? 'User'; // Get the username from UserInfo class
    String email = UserInfo().email ?? '';
    String userId = UserInfo().userId ?? ''; // Get the userId from UserInfo class


    double buttonSize = MediaQuery.of(context).size.width * 0.45;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SidebarMenuUser(
        userProfileName: username, // Pass the username to SidebarMenuUser
        userEmail: email,
        userId: userId, // Pass the userId to SidebarMenuUser
        onHomePressed: () {
          Navigator.pushReplacementNamed(context, '/UserLandingScreen');
        },
        onAboutPressed: () {
          // Add your about functionality here
        },
        onContactPressed: () {
          // Add your contact functionality here
        },
        onGalleryPressed: () {
          // Add your gallery functionality here
        },
        onMapPressed: () {
          // Add your map functionality here
        },
        onSettingsPressed: () {
          // Add your settings functionality here
        },
        onLogoutPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Blue big square button for "Create Quiz"
                Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to create quiz screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DisplayQuizForUser()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Browse available Quiz',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add spacing between buttons
                // Blue big square button for "Manage Quiz"
                Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the DisplayQuizzesScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizResultsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'View Quiz Result',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add spacing between rows
            // Blue big square button for "Scoreboard"
          ],
        ),
      ),
    );
  }
}
