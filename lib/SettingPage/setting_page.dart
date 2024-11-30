import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String profileImageUrl = ''; // Replace with default or fetched URL
  String username = 'User123'; // Replace with fetched username
  String phoneNumber = '1234567890'; // Replace with fetched phone number
  bool notificationsEnabled = true;
  String selectedFont = 'Default';
  bool autoAnswerMode = false;

  void _updateProfileImage() {
    // Add logic to update the profile image
    print("Profile Image Updated");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _updateProfileImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username: $username",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Phone: $phoneNumber",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            // Notification Settings
            SwitchListTile(
              title: Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            Divider(),
            // Font Settings
            ListTile(
              title: Text("Default Font"),
              trailing: DropdownButton<String>(
              value: themeProvider.selectedFont,
              dropdownColor: themeProvider.isDarkMode ? Colors.grey[850] : Colors.white, // Set dropdown background color
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black, // Set text color
              ),
              items: <String>['Default', 'Sans', 'Serif', 'Monospace']
                  .map((font) => DropdownMenuItem<String>(
                        value: font,
                        child: Text(
                          font,
                          style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black, // Adjust item text color
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                themeProvider.updateFont(value!);
              },
            ),
            ),
            Divider(),
            // Dark Mode
            SwitchListTile(
              title: Text("Dark Mode"),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            Divider(),
            // Auto Answer Mode
            SwitchListTile(
              title: Text("Auto-Answer Mode"),
              value: autoAnswerMode,
              onChanged: (value) {
                setState(() {
                  autoAnswerMode = value;
                });
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
