import 'package:flutter/material.dart';
import 'dart:async'; // For countdown timer

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  int countdown = 3; // Initialize countdown variable

  void _submitNewPassword() {
    if (_newPasswordController.text.isEmpty ||
        _newPasswordController.text != _confirmPasswordController.text) {
      // Show error if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match or are empty.')),
      );
    } else {
      // Password successfully changed
      _showSuccessNotification();
    }
  }

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully!')),
    );

    // Start the countdown and navigate to login screen
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your new password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitNewPassword,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 24),
            if (countdown < 3)
              Center(
                child: Text(
                  'Redirecting to login screen in $countdown...',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
