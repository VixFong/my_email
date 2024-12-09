// import 'package:flutter/material.dart';
// import 'package:final_essays/service/ApiService.dart';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String otpToken;

//   OtpScreen({required this.phoneNumber, required this.otpToken});

//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController otpController = TextEditingController();
//   String errorMessage = '';

//   void verifyOtp() async {
//     final String otp = otpController.text;

//     ApiService apiService = ApiService();
//     print(otp);
//     bool isVerified = await apiService.verifyOtp(widget.otpToken, otp);

//     if (isVerified) {
//       // Navigate to EmailPage on successful OTP verification
//       Navigator.pushReplacementNamed(context, '/email');
//     } else {
//       // Show error if OTP verification failed
//       setState(() {
//         errorMessage = 'Invalid OTP. Please try again.';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter OTP'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'OTP sent to: ${widget.phoneNumber}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),

//               // OTP Field
//               TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(
//                   labelText: 'OTP',
//                   border: OutlineInputBorder(),
//                   errorText: errorMessage.isNotEmpty ? errorMessage : null,
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Verify Button
//               ElevatedButton(
//                 onPressed: verifyOtp,
//                 child: Text('Verify', style: TextStyle(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:final_essays/model/CreateRecipientReq.dart';
// import 'package:final_essays/service/ApiService.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'file_utils.dart';

// class ComposeEmailForm extends StatefulWidget {
//   @override
//   _ComposeEmailFormState createState() => _ComposeEmailFormState();
// }

// class _ComposeEmailFormState extends State<ComposeEmailForm> {
//   final TextEditingController _toController = TextEditingController();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();
//   final List<Map<String, String>> _attachments = []; // Store file name and path
//   List<Map<String, dynamic>> _searchResults = [];
//   String? _selectedUserId;
//   String? id;

//   List<Recipient> _recipients = [];
//   List<File> _attachment = [];

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       id = prefs.getString('id');
//     });
//   }

//   final ApiService _apiService = ApiService();

//   Future<void> _searchUsers(String keyword) async {
//     if (keyword.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }

//     var results = await _apiService.searchUsers(keyword);
//     setState(() {
//       _searchResults = results;
//     });
//   }

//   void _addRecipient(String userId, String email, RecipientType type) {
//     setState(() {
//       _recipients.add(Recipient(userId: userId, email: email, type: type));
//     });
//   }

//   void _removeRecipient(int index) {
//     setState(() {
//       _recipients.removeAt(index);
//     });
//   }

//   Widget _recipientTypeDropdown(
//       RecipientType selectedType, Function(RecipientType?) onChange) {
//     return DropdownButton<RecipientType>(
//       value: selectedType,
//       onChanged: onChange,
//       items: RecipientType.values.map((RecipientType type) {
//         return DropdownMenuItem<RecipientType>(
//           value: type,
//           child: Text(type.toString().split('.').last),
//         );
//       }).toList(),
//     );
//   }

//   Widget _recipientList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: _recipients.length,
//       itemBuilder: (context, index) {
//         final recipient = _recipients[index];
//         return ListTile(
//           title: Text(recipient.email),
//           subtitle: Text(recipient.type.toString().split('.').last),
//           trailing: IconButton(
//             icon: Icon(Icons.remove_circle, color: Colors.red),
//             onPressed: () => _removeRecipient(index),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _attachments.addAll(result.files.map((file) => {
//               'name': file.name,
//               'path': file.path ?? '',
//             }));
//       });
//     }
//   }

//   void _removeAttachment(int index) {
//     setState(() {
//       _attachments.removeAt(index);
//     });
//   }

//   Future<void> _sendEmail() async {
//     if (_recipients.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please add at least one recipient.")),
//       );
//       return;
//     }

//     try {
//       // List<Map<String, dynamic>> recipientData =
//       //     _recipients.map((r) => r.toJson()).toList();

//       List<MultipartFile> attachmentFiles = await Future.wait(
//         _attachments.map((file) async {
//           String fileName = file['path']!.split('/').last;
//           return await MultipartFile.fromFile(file['path']!,
//               filename: fileName);
//         }).toList(),
//       );

//       await _apiService.sendEmail(
//         senderId: id!,
//         subject: _titleController.text,
//         body: _contentController.text,
//         isDraft: false,
//         recipients: _recipients.map((recipient) => recipient.toJson()).toList(),
//         attachments: attachmentFiles,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Email sent successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Compose Email',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _toController,
//             decoration: const InputDecoration(
//               labelText: 'Send To',
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               _searchUsers(value);
//             },
//           ),
//           if (_searchResults.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(top: 8),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//               ),
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _searchResults.length,
//                 itemBuilder: (context, index) {
//                   final user = _searchResults[index];
//                   RecipientType selectedType = RecipientType.TO;
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(user['profilePic'] ?? ""),
//                     ),
//                     title: Text(user['email']),
//                     trailing: _recipientTypeDropdown(selectedType, (newType) {
//                       selectedType = newType!;
//                     }),
//                     onTap: () {
//                       _addRecipient(user['id'], user['email'], selectedType);
//                       _searchResults.clear();
//                     },
//                   );
//                 },
//               ),
//             ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(
//               labelText: 'Title',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _contentController,
//             maxLines: 5,
//             decoration: const InputDecoration(
//               labelText: 'Content',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),
//           if (_recipients.isNotEmpty) _recipientList(),
//           const SizedBox(height: 16),
//           if (_attachments.isNotEmpty)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Attachments:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: _attachments.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     Map<String, String> file = entry.value;
//                     return Chip(
//                       label: Text(file['name'] ?? 'Unknown File'),
//                       onDeleted: () => _removeAttachment(index),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           const SizedBox(height: 24),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton.icon(
//               onPressed: _sendEmail,
//               icon: const Icon(Icons.send),
//               label: const Text('Send'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }