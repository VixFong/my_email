import 'package:final_essays/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String profileImageUrl = ''; // Replace with default or fetched URL
  String email = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String gender = '';
  String password = '';
  String gmailAccount = '';
  bool notificationsEnabled = true;
  String selectedFont = 'Default';
  bool autoAnswerMode = false;
  String? token;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _gmailAccountController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final apiService = ApiService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    if (token != null) {
      try {
        final result = await apiService.getProfile(token!);
        if (result.isSuccess) {
          final user = result.data;
          setState(() {
            profileImageUrl = user!.profilePic; // URL ảnh profile
            email = user.email;
            firstName = user.firstName;
            lastName = user.lastName;
            phoneNumber = user.phoneNumber;
            gender = user.gender;
            gmailAccount = user.gmailAccount;
          
            _firstNameController.text = user.firstName; 
            _lastNameController.text = user.lastName; 
            _phoneNumberController.text = user.phoneNumber; 
            _genderController.text = user.gender;
            _gmailAccountController.text = user.gmailAccount;
            _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(user.dateOfBirth);
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

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
                        "Email: $email",
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
                dropdownColor: themeProvider.isDarkMode
                    ? Colors.grey[850]
                    : Colors.white, // Set dropdown background color
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black, // Set text color
                ),
                items: <String>['Default', 'Sans', 'Serif', 'Monospace']
                    .map((font) => DropdownMenuItem<String>(
                          value: font,
                          child: Text(
                            font,
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black, // Adjust item text color
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
