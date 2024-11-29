// import 'package:final_essays/service/ApiService.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String otpToken;
//   OtpScreen({required this.phoneNumber, required this.otpToken});

//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
//   // final String correctOtp = '111111'; // Example OTP
//   String errorMessage = '';

//   void checkOtp() async{
//     // Combine all text field values
//     String enteredOtp = controllers.map((controller) => controller.text).join();
//     // final String otp = otpController.text;
//     ApiService apiService = ApiService();
//     bool isVerified = await apiService.verifyOtp(widget.otpToken, enteredOtp);

//     if (isVerified) {
//       // OTP matches - Show success and navigate to login
//       setState(() {
//         errorMessage = '';
//       });

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           content: Text("Registration successful! Redirecting to login..."),
//         ),
//       );

//       // Redirect to login screen after 2 seconds
//       Future.delayed(Duration(seconds: 2), () {
//         Navigator.of(context).pop(); // Close the dialog
//         Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the root (login screen)
//       });
//     } else {
//       // OTP does not match - Show error message
//       setState(() {
//         errorMessage = 'Invalid OTP. Please try again.';
//       });
//       // Clear all fields for retry
//       controllers.forEach((controller) => controller.clear());
//       // Focus on the first field
//       FocusScope.of(context).requestFocus(_focusNodes[0]);
//     }
//   }

//   List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

//   @override
//   void initState() {
//     super.initState();
//     // Automatically focus on the first text field
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).requestFocus(_focusNodes[0]);
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose controllers and focus nodes
//     controllers.forEach((controller) => controller.dispose());
//     _focusNodes.forEach((node) => node.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Authentication'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Enter the 6-digit OTP sent to your phone',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 16),

//               // OTP Input Fields
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(6, (index) {
//                   return Container(
//                     width: 40,
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     child: TextField(
//                       controller: controllers[index],
//                       focusNode: _focusNodes[index],
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         counterText: '', // Remove counter text
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           // Move to the next field
//                           if (index < 5) {
//                             FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//                           } else {
//                             // Last field - Check OTP
//                             checkOtp();
//                           }
//                         } else if (index > 0) {
//                           // Move to the previous field if empty
//                           FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 16),

//               // Error Message
//               if (errorMessage.isNotEmpty)
//                 Text(
//                   errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final Function onResendOtp; // Hàm gửi lại OTP
  final Function(String otp) onSubmitOtp; // Hàm xử lý OTP

  OtpScreen({required this.onResendOtp, required this.onSubmitOtp});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());
  String errorMessage = '';
  bool isResending = false;

  void checkOtp() {
    String enteredOtp = controllers.map((controller) => controller.text).join();
    if (enteredOtp.length == 6) {
      widget.onSubmitOtp(enteredOtp); // Gửi OTP về callback
    } else {
      setState(() {
        errorMessage = 'Please enter a 6-digit OTP.';
      });
    }
  }

  Future<void> resendOtp() async {
    setState(() {
      isResending = true;
      errorMessage = ''; // Xóa thông báo lỗi khi gửi lại OTP
    });
    await widget.onResendOtp(); // Gọi hàm gửi lại OTP
    setState(() {
      isResending = false;
    });
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the 6-digit OTP sent to your phone',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: controllers[index],
                      focusNode: _focusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '', // Remove counter text
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),

              // Error Message
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16),

              // Resend OTP Button
              ElevatedButton(
                onPressed: isResending ? null : resendOtp,
                child: isResending
                    ? CircularProgressIndicator()
                    : Text('Resend OTP'),
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: checkOtp,
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
