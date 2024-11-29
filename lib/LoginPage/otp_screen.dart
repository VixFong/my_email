import 'package:flutter/material.dart';
import 'package:final_essays/service/ApiService.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otpToken;

  OtpScreen({required this.phoneNumber, required this.otpToken});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  String errorMessage = '';

  void verifyOtp() async {
    final String otp = otpController.text;

    ApiService apiService = ApiService();
    print(otp);
    bool isVerified = await apiService.verifyOtp(widget.otpToken, otp);

    if (isVerified) {
      // Navigate to EmailPage on successful OTP verification
      Navigator.pushReplacementNamed(context, '/email');
    } else {
      // Show error if OTP verification failed
      setState(() {
        errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP sent to: ${widget.phoneNumber}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // OTP Field
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
              ),
              SizedBox(height: 16),

              // Verify Button
              ElevatedButton(
                onPressed: verifyOtp,
                child: Text('Verify', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
