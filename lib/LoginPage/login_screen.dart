import 'package:final_essays/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../ForgotPage/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String errorMessage = '';

  void validatePhoneNumber(String phoneNumber, String region) async {
    final String phoneNumber = phoneController.text;
    ApiService apiService = ApiService();
    final isValid = await apiService.validatePhoneNumber(phoneNumber, region);

    if (isValid) {
      // Valid phone number, navigate to password screen with the phone number
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordScreen(phoneNumber: phoneNumber),
        ),
      ).then((returnedPhoneNumber) {
        if (returnedPhoneNumber != null) {
          phoneController.text = returnedPhoneNumber; // Restore phone number
        }
      });
    } else {
      // Invalid phone number, show error message
      setState(() {
        errorMessage = 'Invalid phone number. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: Colors.blue,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Sign In',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Continue to Your Service',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 32),
              IntlPhoneField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
                initialCountryCode: 'VN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  // Debugging purposes
                },
              ),
              SizedBox(height: 16),

              // Row for "Forgot phone number?" and "Create account"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(), 
                        ),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Registration Screen
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Create account',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Next Button
              ElevatedButton(
                onPressed: () {
                  final phoneNumber = phoneController.text;
                  final region = 'VN';
                  validatePhoneNumber(phoneNumber, region);
                },
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
