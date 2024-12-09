  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:provider/provider.dart';
  import '../theme_provider.dart';
  import 'package:file_picker/file_picker.dart';

  class SettingsPage extends StatefulWidget {
    final Function(String) onProfileImageChanged;

    SettingsPage({required this.onProfileImageChanged});

    @override
    _SettingsPageState createState() => _SettingsPageState();
  }

  class _SettingsPageState extends State<SettingsPage> {
    String profileImageUrl = ''; // Path to the profile picture
    String username = 'User123'; // Default username
    String phoneNumber = '1234567890'; // Default phone number
    bool notificationsEnabled = true;
    String selectedFont = 'Default';
    bool autoAnswerMode = false;
    final picker = ImagePicker();

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    @override
    void initState() {
      super.initState();
      usernameController.text = username;
      phoneNumberController.text = phoneNumber;
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

    // Function to update username
    void _updateUsername() {
      setState(() {
        username = usernameController.text;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Username updated!")));
    }

    // Function to update phone number
    void _updatePhoneNumber() {
      setState(() {
        phoneNumber = phoneNumberController.text;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Phone number updated!")));
    }

    // Function to update password
    void _updatePassword() {
      if (oldPasswordController.text.isNotEmpty &&
          newPasswordController.text.isNotEmpty) {
        // Add validation logic here
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Password updated!")));
        oldPasswordController.clear();
        newPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please fill in all password fields.")));
      }
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: _updateUsername,
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
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: _updatePhoneNumber,
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
                      controller: oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter old password",
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: _updatePassword,
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
