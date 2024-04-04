import 'package:flutter/material.dart';

// Import SidebarMenu widget
import 'sidebar_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: SidebarMenu( // Add SidebarMenu as drawer
        userProfileName: 'John Doe', // Example user profile name
        onHomePressed: () {
          // Implement logic for Home button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the home page
        },
        onAboutPressed: () {
          // Implement logic for About button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the about page
        },
        onContactPressed: () {
          // Implement logic for Contact button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the contact page
        },
        onGalleryPressed: () {
          // Implement logic for Gallery button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the gallery page
        },
        onMapPressed: () {
          // Implement logic for Map button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the map page
        },
        onSettingsPressed: () {
          // Implement logic for Settings button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the settings page
        },
        onLogoutPressed: () {
          // Implement logic for Logout button pressed
          // Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as logging out the user
        },
        onDashboardPressed: () {
          Navigator.pop(context); // Close the drawer if needed
          // Add your logic here, such as navigating to the dashboard page
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Overview',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Total Sales: \$10,000'),
                    Text('Today\'s Sales: \$1,000'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Stats',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Total Products: 100'),
                    Text('New Products: 5'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Engagement',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Total Users: 500'),
                    Text('Active Users: 100'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
