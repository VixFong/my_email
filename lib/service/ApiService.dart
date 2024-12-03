import 'dart:convert';
import 'dart:io';
import 'package:final_essays/model/ErrorResponse.dart';
import 'package:final_essays/model/LoginResponse.dart';
import 'package:final_essays/model/OtpResponse.dart';
import 'package:final_essays/model/Result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';

class ApiService {
  late final String baseUrl;
  ApiService() {
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8080'; // Android Emulator
    } else if (Platform.isIOS) {
      baseUrl = 'http://127.0.0.1:8080'; // iOS Simulator
    } else if (Platform.isWindows) {
      baseUrl = 'http://localhost:8080'; // Windows localhost
    } else if (Platform.isLinux || Platform.isMacOS) {
      baseUrl = 'http://127.0.0.1:8080'; // Linux/MacOS localhost
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
  Future<LoginResponse?> login(String phoneNumber, String password) async {
    // print(phoneNumber);
    // print(password);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );
      // print(response.body);
      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');

        final responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData['data']);

        if (loginResponse.authenticated && loginResponse.token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginResponse.token!);
        }

        return loginResponse;
        // final userJson = responseData['data'];

        // Kiểm tra JSON
        // print('User JSON: $userJson');
        // Parse JSON thành User object
        // return User.fromJson(userJson);
      } else {
        print('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    // return null;
  }

  // Future<Result<OtpResponse>> registerUser(
  //     Map<String, dynamic> userData) async {
  //   try {
  //     print(userData);
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/users/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(userData),
  //     );

  //     if (response.statusCode == 200) {
  //       print('User registered successfully');
  //       final responseData = jsonDecode(response.body);
  //       final dataJson = responseData['data'];

  //       print(dataJson);

  //       if (dataJson != null) {
  //         final otpResponse = OtpResponse.fromJson(dataJson);
  //         return Result(data: otpResponse);
  //       } else {
  //         // final error = responseData['message'];
  //         // return Result(error: ErrorResponse(errorCode: errorCode, message: message))
  //         return Result(
  //             error: ErrorResponse(
  //                 errorCode: "INVALID_RESPONSE",
  //                 message: "Invalid response data"));
  //       }
  //     } else {
  //       print('aaaaaaaa');
  //       print('Registration failed: ${response.statusCode}');
  //       print('Error: ${response.body}');
  //       final responseData = jsonDecode(response.body);
  //       final errorResponse = ErrorResponse.fromJson(responseData);
  //       return Result(error: errorResponse);
  //     }
  //   } catch (e) {
  //     print('Error during registration: $e');
  //     return Result(error: ErrorResponse(errorCode: "EXCEPTION", message: e.toString()));
  //   }
  // }

  Future<Result<OtpResponse>> registerUser(
      Map<String, dynamic> userData) async {
    try {
      print('User Data: $userData');
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('User registered successfully');
        final responseData = jsonDecode(response.body);
        final dataJson = responseData['data'];

        print('Response Data: $responseData');
        print('Data JSON: $dataJson');

        if (dataJson != null) {
          final otpResponse = OtpResponse.fromJson(dataJson);
          return Result(data: otpResponse);
        } else {
          print('Invalid response data');
          return Result(
            error: ErrorResponse(
              code: 403,
              message: "Invalid response data",
            ),
          );
        }
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        final responseData = jsonDecode(response.body);
        final errorResponse = ErrorResponse.fromJson(responseData);
        return Result(error: errorResponse);
      }
    } catch (e) {
      print('Error during registration: $e');
      return Result(
        error: ErrorResponse(
          code: 404,
          message: e.toString(),
        ),
      );
    }
  }

  Future<Result<bool>> verifiedOtpRegister(
      String otpToken, String otpProvided) async {
    try {
      print("Verty");
      print(otpToken);
      print(otpProvided);
      final response = await http.get(
        Uri.parse(
            '$baseUrl/users/verify-otp?otpToken=$otpToken&otpProvided=$otpProvided'),
      );
      if (response.statusCode == 200) {
        return Result(data: true);
      } else {
        final responseData = jsonDecode(response.body);
        final errorResponse = ErrorResponse.fromJson(responseData);
        print('Vertification failed: ${response.statusCode}');
        print('Error: ${response.body}');
        return Result(error: errorResponse);
      }
    } catch (e) {
      print('Error during registration: $e');
      return Result(error: ErrorResponse(code: 404, message: e.toString()));
    }
  }

  Future<bool> validatePhoneNumber(String phoneNumber, String region) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/auth/verify-phoneNumber?phoneNumber=$phoneNumber&region=$region'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        print('Validation fail:');
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> verifyOtp(String otpToken, String otp) async {
    try {
      print(otp);
      final response = await http.post(
        Uri.parse(
            '$baseUrl/auth/verify-otp?otpToken=$otpToken&otpProvided=$otp'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');

        return true;
      } else {
        print('OTP verification failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  Future<void> resendOtp(String otpToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otpToken': otpToken}),
      );
      if (response.statusCode != 200) {
        print('Failed to resend OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
