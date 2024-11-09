import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final String phoneNumber;

  PasswordScreen({required this.phoneNumber});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String errorMessage = '';

  void validatePassword() {
    final String password = passwordController.text;

    if (password == '123456') { // Example password
      // Navigate to EmailPage on successful password validation
      Navigator.pushReplacementNamed(context, '/email');
    } else {
      // Show error if password is incorrect
      setState(() {
        errorMessage = 'Invalid password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Password'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to login screen and keep the phone number entered
            Navigator.pop(context, widget.phoneNumber);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phone Number: ${widget.phoneNumber}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
                obscureText: !showPassword, // Toggle password visibility
              ),
              SizedBox(height: 8),

              // Show Password Checkbox
              Row(
                children: [
                  Checkbox(
                    value: showPassword,
                    onChanged: (bool? value) {
                      setState(() {
                        showPassword = value ?? false;
                      });
                    },
                  ),
                  Text('Show password'),
                ],
              ),
              SizedBox(height: 16),

              // Forgot Password link and Next Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Implement 'Forgot Password?' functionality
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: validatePassword,
                    child: Text('Next',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(100, 50),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
