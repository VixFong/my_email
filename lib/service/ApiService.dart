import 'dart:convert';
import 'dart:io';
import 'package:final_essays/model/ErrorResponse.dart';
import 'package:final_essays/model/LoginResponse.dart';
import 'package:final_essays/model/OtpResponse.dart';
import 'package:final_essays/model/CreateRecipientReq.dart';
import 'package:final_essays/model/Result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/User.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final String baseUrl = 'http://localhost:8080';
  ApiService() {
    // if (Platform.isAndroid) {
    //   baseUrl = 'http://10.0.2.2:8080'; // Android Emulator
    // } else if (Platform.isIOS) {
    //   baseUrl = 'http://127.0.0.1:8080'; // iOS Simulator
    // } else if (Platform.isWindows) {
    //   baseUrl = 'http://localhost:8080'; // Windows localhost
    // } else if (Platform.isLinux || Platform.isMacOS) {
    //   baseUrl = 'http://127.0.0.1:8080'; // Linux/MacOS localhost
    // } else {
    //   print('aaaaa');
    //   baseUrl = 'http://localhost:8080';
    //   // throw UnsupportedError("Unsupported platform");
    // }
  }
  Future<LoginResponse?> login(String phoneNumber, String password) async {
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
          await prefs.setString('id', loginResponse.id!);
          await prefs.setString('profilePic', loginResponse.profilePic ?? '');
          await prefs.setString('email', loginResponse.email ?? '');
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

  Future<Result<User>> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/users/info');
    print('token $token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final dataJson = responseData['data'];
        print(dataJson);
        if (dataJson != null) {
          final userResponse = User.fromJson(dataJson);
          return Result(data: userResponse);
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
        print('Get profile failed with status code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        final responseData = jsonDecode(response.body);
        final errorResponse = ErrorResponse.fromJson(responseData);
        return Result(error: errorResponse);
      }
    } catch (e) {
      print('Error during get profile user: $e');
      return Result(
        error: ErrorResponse(
          code: 404,
          message: e.toString(),
        ),
      );
    }
    // return User.fromJson(data['data']); // `data` là cấu trúc JSON trả về từ API
    //   } else {
    //     throw Exception('Failed to load user info. Status Code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   throw Exception('Error fetching user info: $e');
  }

  Future<List<Map<String, dynamic>>> searchUsers(String keyword) async {
    try {
      Dio dio = Dio();
      print(keyword);
      // Lấy token từ local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Replace 'token' with your key

      if (token == null) {
        throw Exception("Token not found. Please log in again.");
      }

      // Thiết lập headers
      final options = Options(
        headers: {
          "Authorization": "Bearer $token", // Gửi token trong header
          "Content-Type": "application/json",
        },
      );
      var response = await dio.get(
        '$baseUrl/users/search',
        queryParameters: {'keyword': keyword},
        options: options,
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // Future<void> sendEmail({
  //   // required String senderId,
  //   required String subject,
  //   required String body,
  //   required bool isDraft,
  //   // required List<Map<String, dynamic>> recipients,
  //   required List<CreateRecipientReq> recipients,
  //   List<MultipartFile>? attachments,
  // }) async {
  //   Dio _dio = Dio();
  //   // Lấy token từ local storage
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token'); // Replace 'token' with your key
  //   String? senderId = prefs.getString('id');
  //   if (token == null) {
  //     throw Exception("Token not found. Please log in again.");
  //   }

  //   // Thiết lập headers
  //   final options = Options(
  //     headers: {
  //       "Authorization": "Bearer $token", // Gửi token trong header
  //       "Content-Type": "multipart/form-data",
  //     },
  //   );

  //   print(recipients);
  //   try {
  //     // Convert the CreateRecipientReq list into a list of maps
  //     // List<Map<String, String>> recipientsMap = recipients.map((recipient) {
  //     //   return {
  //     //     "userId": recipient.userId,
  //     //     "type": recipient.type,
  //     //   };
  //     // }).toList();

  //     FormData formData = FormData.fromMap({
  //       "senderId": senderId,
  //       "subject": subject,
  //       "body": body,
  //       "isDraft": isDraft,
  //       // "recipients": recipients,
  //       // "recipients": recipientsMap,
  //       "recipients": recipients.map((recipient) {
  //         return {
  //           "userId": recipient.userId,
  //           "type": recipient.type,
  //         };
  //       }).toList(), // Convert the list of CreateRecipientReq to map
  //       "attachments": attachments != null ? attachments : [],
  //     });

  //     Response response =
  //         await _dio.post("$baseUrl/email", data: formData, options: options);

  //     if (response.statusCode == 200) {
  //       print("Email sent successfully: ${response.data}");
  //     } else {
  //       print("Failed to send email: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error sending email: $e");
  //     rethrow;
  //   }
  // }

  Future<void> updateEmailAttachments({
    required String emailId,
    required List<MultipartFile> attachments,
  }) async {
    Dio _dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token not found. Please log in again.");
    }

    FormData formData = FormData.fromMap({
      //     'attachments': attachments.map((file) {
      //         return MultipartFile.fromBytes(
      //             file.bytes!,
      //             filename: file.filename,
      //         );
      //     }).toList(),
      "attachments": attachments,
    });

    final response = await _dio.post(
      '$baseUrl/email/attachments/$emailId',
      data: formData,
      options: Options(headers: {
        "Authorization": "Bearer $token",
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update attachments");
    }
  }

  Future<void> sendEmail({
    required String subject,
    required String body,
    required bool isDraft,
    required List<CreateRecipientReq> recipients,
    List<MultipartFile>? attachments,
  }) async {
    Dio _dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? senderId = prefs.getString('id');

    if (token == null) {
      throw Exception("Token not found. Please log in again.");
    }

    print("draft $isDraft");
    // final response = await http.post(
    //   Uri.parse('$baseUrl/email/compose'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     "Authorization": "Bearer $token",
    //   },
    //   body: jsonEncode({
    //     'senderId': senderId,
    //     'subject': subject,
    //     'body': body,
    //     'isDraft': isDraft,
    //     "recipients": recipients.map((recipient) {
    //       return {
    //         "userId": recipient.userId,
    //         "type": recipient.type,
    //       };
    //     }).toList(),
    //   }),
    // );
    final bodyData = {
      'senderId': senderId,
      'subject': subject,
      'body': body,
      'isDraft': isDraft,
      "recipients": recipients.map((recipient) {
        return {
          "userId": recipient.userId,
          "type": recipient.type,
        };
      }).toList(),
    };
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/email/compose'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );
      print("Request Body: $bodyData");
      if (attachments != null && attachments.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        final dataJson = responseData['data'];

        await updateEmailAttachments(
            emailId: dataJson, attachments: attachments);
      }
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final dataJson = responseData['data'];
        print("Email sent successfully: $dataJson");
      } else {
        print("Failed to send email: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending email: $e");
      rethrow;
    }
  }
  // final options = Options(
  //   headers: {
  //     "Authorization": "Bearer $token",
  //     "Content-Type": attachments != null && attachments.isNotEmpty
  //         ? "multipart/form-data"
  //         : "application/json",
  //   },
  // );
  // print(attachments);
  // // try {
  // // Convert recipients to the expected format
  // List<Map<String, String>> recipientsMap = recipients.map((recipient) {
  //   return {
  //     "userId": recipient.userId,
  //     "type": recipient.type,
  //   };
  // }).toList();

  // dynamic requestData;

  // if (attachments != null && attachments.isNotEmpty) {
  //   // Multipart data
  //   FormData formData = FormData.fromMap({
  //     "senderId": senderId,
  //     "subject": subject,
  //     "body": body,
  //     "isDraft": isDraft,
  //     "recipients": jsonEncode(recipientsMap), // Encode JSON for multipart
  //     "attachments": attachments,
  //   });
  //   requestData = formData;
  // } else {
  //   // JSON data
  //   requestData = {
  //     "senderId": senderId,
  //     // "subject": subject,
  //     // "body": body,
  //     // "isDraft": isDraft,
  //     // "recipients": recipientsMap, // Directly use JSON
  //   };
  // }

  // print("Form data: ${requestData}");

  // Response response = await _dio.post("$baseUrl/email/compose",
  //     data: requestData, options: options);

  // Helper to prepare recipient data
  // List<Map<String, dynamic>> prepareRecipients(List<Recipient> recipients) {
  //   return recipients
  //       .map((recipient) => {
  //             "userId": recipient.userId,
  //             "type": recipient.type.toString().split('.').last,
  //           })
  //       .toList();
  // }

  // Future<void> composeEmail({
  //   required String senderId,
  //   required String subject,
  //   required String body,
  //   required bool isDraft,
  //   required List<Map<String, dynamic>> recipients,
  //   required List<File> attachments,
  // }) async {
  //   final Dio _dio = Dio();
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token'); // Replace 'token' with your key

  //     if (token == null) {
  //       throw Exception("Token not found. Please log in again.");
  //     }

  //     // Thiết lập headers
  //     final options = Options(
  //       headers: {
  //         "Authorization": "Bearer $token", // Gửi token trong header
  //         "Content-Type": "multipart/form-data",
  //       },
  //     );

  //     // Chuẩn bị dữ liệu request
  //     final formData = FormData.fromMap({
  //       "senderId": senderId,
  //       "subject": subject,
  //       "body": body,
  //       "isDraft": isDraft,
  //       "recipients": recipients
  //           .map((recipient) => {
  //                 "userId": recipient["userId"],
  //                 "type": recipient["type"],
  //               })
  //           .toList(),
  //       "attachments": attachments.map((file) => MultipartFile.fromFileSync(
  //             file.path,
  //             filename: file.path.split('/').last,
  //           )),
  //     });

  //     // Gửi request đến API backend
  //     final response = await _dio.post(
  //       "$baseUrl/email",
  //       data: formData,
  //       options: options,
  //     );

  //     if (response.statusCode == 200) {
  //       print("Email sent successfully!");
  //     } else {
  //       throw Exception(
  //           "Failed to send email. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error in sending email: $e");
  //     throw Exception("Error in sending email: $e");
  //   }
  // }
  // Future<void> composeEmail({
  //   required int senderId,
  //   required String subject,
  //   required String body,
  //   required bool isDraft,
  //   required List<Map<String, dynamic>> recipients,
  //   required List<File> attachments,
  // }) async {
  //   var dio = Dio();
  //   FormData formData = FormData();
  //   formData.fields.add(MapEntry('senderId', senderId.toString()));
  //   formData.fields.add(MapEntry('subject', subject));
  //   formData.fields.add(MapEntry('body', body));
  //   formData.fields.add(MapEntry('isDraft', isDraft.toString()));
  //   for (int i = 0; i < recipients.length; i++) {
  //     formData.fields.addAll([
  //       MapEntry('recipients[$i].userId', recipients[i]['userId'].toString()),
  //       MapEntry('recipients[$i].type', recipients[i]['type'].toString())
  //     ]);
  //   }
  //   for (var file in attachments) {
  //     String fileName = file.path.split('/').last;
  //     formData.files.add(MapEntry(
  //       'attachments',
  //       await MultipartFile.fromFile(file.path, filename: fileName),
  //     ));
  //   }
  //   try {
  //     var response = await dio.post('$baseUrl/email', data: formData);
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.data}');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
