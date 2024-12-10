import 'package:final_essays/service/ApiService.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';
import 'package:file_picker/file_picker.dart';

class SettingsPage extends StatefulWidget {
  final Function(String) onProfileImageChanged;

  SettingsPage({required this.onProfileImageChanged});

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
  // final picker = ImagePicker();
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
            _dateOfBirthController.text =
                DateFormat('yyyy-MM-dd').format(user.dateOfBirth);
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        setState(() {
          profileImageUrl = path; // Update the image path
        });
      }
    } else {
      // User canceled the picker
      print('No file selected');
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
        title: Text("Settings"),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage, // Open file picker
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? FileImage(File(profileImageUrl))
                          : AssetImage('asset/default_profile.png')
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Tap to change profile picture",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Divider(),
            // Username Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {} //_updateUsername,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            // Phone Number Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {} // _updatePhoneNumber,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            // Password Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    // controller: ,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter old password",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    // controller: ,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter new password",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {} //_updatePassword,
                          ),
                    ),
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
            // Dark Mode
            SwitchListTile(
              title: Text("Dark Mode"),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            Divider(),
            // Auto-Answer Mode
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
