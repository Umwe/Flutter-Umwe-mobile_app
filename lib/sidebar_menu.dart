import 'package:flutter/material.dart';
import 'package:mobile_app_project/UserInfo.dart'; // Import UserInfo class

class SidebarMenu extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onMapPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onLogoutPressed;
  final VoidCallback onDashboardPressed;
  final VoidCallback onSystemGraphPressed;
  final VoidCallback onSharedDataGraphPressed;

  const SidebarMenu({
    Key? key,
    required this.onHomePressed,
    required this.onAboutPressed,
    required this.onContactPressed,
    required this.onGalleryPressed,
    required this.onMapPressed,
    required this.onSettingsPressed,
    required this.onLogoutPressed,
    required this.onDashboardPressed,
    required this.onSystemGraphPressed,
    required this.onSharedDataGraphPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullnames = UserInfo().fullnames ?? 'Full Names'; // Get full names from UserInfo
    String email = UserInfo().email ?? 'example@example.com'; // Get email from UserInfo

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
                  fullnames,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: onDashboardPressed,
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
          ExpansionTile(
            title: Text('Graphs'),
            children: [
              ListTile(
                title: Text('System Graph'),
                onTap: onSystemGraphPressed,
              ),
              ListTile(
                title: Text('Shared Data Graph'),
                onTap: onSharedDataGraphPressed,
              ),
            ],
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
