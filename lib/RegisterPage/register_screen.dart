import 'package:flutter/material.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String? selectedGender;
  String firstNameError = '';
  String phoneError = '';
  String usernameError = '';
  String passwordError = '';

  void register() {
    setState(() {
      // Reset error messages
      firstNameError = '';
      phoneError = '';
      usernameError = '';
      passwordError = '';
    });

    bool isValid = true;

    // First Name validation
    if (firstNameController.text.isEmpty) {
      setState(() {
        firstNameError = 'First name is required.';
      });
      isValid = false;
    }

    // Phone Number validation (must be 10 digits)
    if (phoneNumberController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneNumberController.text)) {
      setState(() {
        phoneError = 'Phone number must be exactly 10 digits.';
      });
      isValid = false;
    }

    // Username validation (required and no spaces)
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameError = 'Username is required.';
      });
      isValid = false;
    } else if (usernameController.text.contains(' ')) {
      setState(() {
        usernameError = 'Username cannot contain spaces.';
      });
      isValid = false;
    }

    // Password validation (must match and be at least 6 characters)
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        passwordError = 'Passwords do not match.';
      });
      isValid = false;
    } else if (passwordController.text.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters long.';
      });
      isValid = false;
    }

    // Proceed to OTP screen if all validations pass
    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Name Field
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // First Name Field with error message
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
                errorText: firstNameError.isNotEmpty ? firstNameError : null,
              ),
            ),
            SizedBox(height: 16),

            // Phone Number Field with error message
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                errorText: phoneError.isNotEmpty ? phoneError : null,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Date of Birth Field
            TextField(
              controller: dateOfBirthController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateOfBirthController.text =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                  });
                }
              },
            ),
            SizedBox(height: 16),

            // Gender Field
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            SizedBox(height: 16),

            // Username Field with "@gmail.com" suffix and error message
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                suffixText: '@gmail.com',
                border: OutlineInputBorder(),
                errorText: usernameError.isNotEmpty ? usernameError : null,
              ),
            ),
            SizedBox(height: 16),

            // Password Field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),

            // Confirm Password Field with error message
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                errorText: passwordError.isNotEmpty ? passwordError : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),

            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
