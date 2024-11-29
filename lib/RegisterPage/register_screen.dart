// import 'package:flutter/material.dart';
// import 'otp_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController dateOfBirthController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   String? selectedGender;
//   String firstNameError = '';
//   String phoneError = '';
//   String usernameError = '';
//   String passwordError = '';

//   void register() {
//     setState(() {
//       // Reset error messages
//       firstNameError = '';
//       phoneError = '';
//       usernameError = '';
//       passwordError = '';
//     });

//     bool isValid = true;

//     // First Name validation
//     if (firstNameController.text.isEmpty) {
//       setState(() {
//         firstNameError = 'First name is required.';
//       });
//       isValid = false;
//     }

//     // Phone Number validation (must be 10 digits)
//     if (phoneNumberController.text.length != 10 ||
//         !RegExp(r'^[0-9]+$').hasMatch(phoneNumberController.text)) {
//       setState(() {
//         phoneError = 'Phone number must be exactly 10 digits.';
//       });
//       isValid = false;
//     }

//     // Username validation (required and no spaces)
//     if (usernameController.text.isEmpty) {
//       setState(() {
//         usernameError = 'Username is required.';
//       });
//       isValid = false;
//     } else if (usernameController.text.contains(' ')) {
//       setState(() {
//         usernameError = 'Username cannot contain spaces.';
//       });
//       isValid = false;
//     }

//     // Password validation (must match and be at least 6 characters)
//     if (passwordController.text != confirmPasswordController.text) {
//       setState(() {
//         passwordError = 'Passwords do not match.';
//       });
//       isValid = false;
//     } else if (passwordController.text.length < 6) {
//       setState(() {
//         passwordError = 'Password must be at least 6 characters long.';
//       });
//       isValid = false;
//     }

//     // Proceed to OTP screen if all validations pass
//     if (isValid) {
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => OtpScreen()),
//       // );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Last Name Field
//             TextField(
//               controller: lastNameController,
//               decoration: InputDecoration(
//                 labelText: 'Last Name (optional)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),

//             // First Name Field with error message
//             TextField(
//               controller: firstNameController,
//               decoration: InputDecoration(
//                 labelText: 'First Name',
//                 border: OutlineInputBorder(),
//                 errorText: firstNameError.isNotEmpty ? firstNameError : null,
//               ),
//             ),
//             SizedBox(height: 16),

//             // Phone Number Field with error message
//             TextField(
//               controller: phoneNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//                 errorText: phoneError.isNotEmpty ? phoneError : null,
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 16),

//             // Date of Birth Field
//             TextField(
//               controller: dateOfBirthController,
//               decoration: InputDecoration(
//                 labelText: 'Date of Birth',
//                 border: OutlineInputBorder(),
//               ),
//               readOnly: true,
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime.now(),
//                 );
//                 if (pickedDate != null) {
//                   setState(() {
//                     dateOfBirthController.text =
//                         "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
//                   });
//                 }
//               },
//             ),
//             SizedBox(height: 16),

//             // Gender Field
//             DropdownButtonFormField<String>(
//               value: selectedGender,
//               decoration: InputDecoration(
//                 labelText: 'Gender',
//                 border: OutlineInputBorder(),
//               ),
//               items: ['Male', 'Female', 'Other']
//                   .map((gender) => DropdownMenuItem(
//                         value: gender,
//                         child: Text(gender),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedGender = value;
//                 });
//               },
//             ),
//             SizedBox(height: 16),

//             // Username Field with "@gmail.com" suffix and error message
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 suffixText: '@gmail.com',
//                 border: OutlineInputBorder(),
//                 errorText: usernameError.isNotEmpty ? usernameError : null,
//               ),
//             ),
//             SizedBox(height: 16),

//             // Password Field
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 16),

//             // Confirm Password Field with error message
//             TextField(
//               controller: confirmPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(),
//                 errorText: passwordError.isNotEmpty ? passwordError : null,
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 32),

//             // Register Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: register,
//                 child: Text('Register'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:final_essays/RegisterPage/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_essays/service/ApiService.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  DateTime? selectedDate;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController gmailAccountController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final ApiService apiService = ApiService();

  String? selectedGender;
  String firstNameError = '';
  String phoneError = '';
  String usernameError = '';
  String gmailAccountError = '';
  String passwordError = '';
  bool isLoading = false;

  void register() async {
    setState(() {
      // Reset error messages
      firstNameError = '';
      phoneError = '';
      usernameError = '';
      gmailAccountError = '';
      passwordError = '';
    });

    bool isValid = true;

    // Validate fields
    if (firstNameController.text.isEmpty) {
      setState(() {
        firstNameError = 'First name is required.';
      });
      isValid = false;
    }

    if (phoneNumberController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneNumberController.text)) {
      setState(() {
        phoneError = 'Phone number must be exactly 10 digits.';
      });
      isValid = false;
    }

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

    if (gmailAccountController.text.isEmpty) {
      setState(() {
        gmailAccountError = 'Gmail is required.';
      });
      isValid = false;
    }
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

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your date of birth.')),
      );
      return;
    }

    if (!isValid) return;

    // Prepare data for API call
    final userData = {
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "phoneNumber": phoneNumberController.text.trim(),
      "dateOfBirth": DateFormat('yyyy-MM-dd').format(selectedDate!),
      "email": usernameController.text.trim() + '@gmail.com',
      "gmailAccount": gmailAccountController.text.trim() + '@gmail.com',
      "password": passwordController.text.trim(),
      "gender": selectedGender,
    };

    setState(() {
      isLoading = true;
    });
    // Call the API
    final result = await apiService.registerUser(userData);

    setState(() {
      isLoading = false;
    });
    if (result.isSuccess) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Registration successful!')),
      // );

      // Navigate to OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            onResendOtp: () {
              // Logic to resend OTP
            },
            onSubmitOtp: (otp) async {
              // Logic to verify OTP
              final vertificationResult =
                  await apiService.verifiedOtpRegister(result.data!.token, otp);
              if (vertificationResult.isSuccess) {
                Navigator.pop(context, true);
              } else {
                setState(() {});
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        // var error = result.error!.message;
        SnackBar(
            content: Text('Registration failed. ${result.error!.message}.')),
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
            if (isLoading) Center(child: CircularProgressIndicator()),
            if (!isLoading) ...[
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
                      // selectedDate = dateFormat.format(pickedDate) as DateTime?;
                      selectedDate = pickedDate;
                      dateOfBirthController.text =
                          DateFormat("dd-MM-yyyy").format(pickedDate);
                      // dateOfBirthController.text =
                      //     DateFormat("dd-MM-yyyy").format(pickedDate);
                      // "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
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

              TextField(
                controller: gmailAccountController,
                decoration: InputDecoration(
                  labelText: 'Gmail',
                  suffixText: '@gmail.com',
                  border: OutlineInputBorder(),
                  errorText:
                      gmailAccountError.isNotEmpty ? gmailAccountError : null,
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
          ],
        ),
      ),
    );
  }
}
