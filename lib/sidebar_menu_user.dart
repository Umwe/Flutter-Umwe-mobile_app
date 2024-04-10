import 'package:flutter/material.dart';

class SidebarMenuUser extends StatelessWidget {
  final String userProfileName;
  final String userEmail; // Added user email field
  final String userId;

  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onMapPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onLogoutPressed;

  const SidebarMenuUser({
    Key? key,
    required this.userProfileName,
    required this.userEmail, // Initialize user email in the constructor
    required this.userId,
    required this.onHomePressed,
    required this.onAboutPressed,
    required this.onContactPressed,
    required this.onGalleryPressed,
    required this.onMapPressed,
    required this.onSettingsPressed,
    required this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, $userProfileName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: $userEmail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(

                  'User ID: $userId',
                   // Display user email in the DrawerHeader
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/UserLandingScreen');
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: onAboutPressed,
          ),
          ListTile(
            title: Text('Contact'),
            onTap: onContactPressed,
          ),
          ListTile(
            title: Text('Gallery'),
            onTap: onGalleryPressed,
          ),
          ListTile(
            title: Text('Map'),
            onTap: onMapPressed,
          ),
          Divider(),
          ListTile(
            title: Text('Settings'),
            onTap: onSettingsPressed,
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
