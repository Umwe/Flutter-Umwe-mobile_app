import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final String userProfileName;
  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onMapPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onLogoutPressed;

  const SidebarMenu({
    Key? key,
    required this.userProfileName,
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
            child: Text(
              'Welcome, $userProfileName',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: onHomePressed,
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
            onTap: onLogoutPressed,
          ),
        ],
      ),
    );
  }
}
