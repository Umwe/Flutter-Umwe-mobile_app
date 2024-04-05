import 'package:flutter/material.dart';
import 'CreateQuizScreen.dart';
import 'DisplayQuizzesScreen.dart';
import 'ScoreboardPage.dart';
import 'UserInfo.dart';
import 'sidebar_menu.dart'; // Import your SidebarMenu widget

class AdminLandingScreen extends StatelessWidget {
  // Placeholder callback functions for menu items
  void onHomePressed(BuildContext context) {
    // Implement logic for Home button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the home page
  }

  void onAboutPressed(BuildContext context) {
    // Implement logic for About button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the about page
  }

  void onContactPressed(BuildContext context) {
    // Implement logic for Contact button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the contact page
  }

  void onGalleryPressed(BuildContext context) {
    // Implement logic for Gallery button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the gallery page
  }

  void onMapPressed(BuildContext context) {
    // Implement logic for Map button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the map page
  }

  void onSettingsPressed(BuildContext context) {
    // Implement logic for Settings button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the settings page
  }

  void onLogoutPressed(BuildContext context) {
    // Implement logic for Logout button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as logging out the user
  }

  void onDashboardPressed(BuildContext context) {
    // Implement logic for Dashboard button pressed
    Navigator.pop(context); // Close the drawer if needed
    // Add your logic here, such as navigating to the dashboard page
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width * 0.45;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: SidebarMenu(
        userProfileName: UserInfo().username ?? 'Admin', // Use UserInfo username or 'Guest' as fallback
        onHomePressed: () => onHomePressed(context),
        onAboutPressed: () => onAboutPressed(context),
        onContactPressed: () => onContactPressed(context),
        onGalleryPressed: () => onGalleryPressed(context),
        onMapPressed: () => onMapPressed(context),
        onSettingsPressed: () => onSettingsPressed(context),
        onLogoutPressed: () => onLogoutPressed(context),
        onDashboardPressed: () => onDashboardPressed(context),
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
                      // Implement logic for Create Quiz button pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateQuizScreen()),
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
                        'Create Quiz',
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
                      // Implement logic for Manage Quiz button pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DisplayQuizzesScreen()),
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
                        'Manage Quiz',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add spacing between rows
            // Blue big square button for "Scoreboard"
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ScoreboardPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScoreboardPage()),
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
                    'Scoreboard',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}