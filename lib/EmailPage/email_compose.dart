// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:final_essays/model/Recipient.dart';
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

//   void _selectUser(Map<String, dynamic> user) {
//     setState(() {
//       _toController.text = user['email'];
//       _selectedUserId = user['id'];
//       // _searchResults.clear();
//       _searchResults = [];
//     });
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _attachments.addAll(result.files.map((file) => {
//               'name': file.name,
//               // 'bytes': file.bytes,
//               'path': file.path ?? '',
//             }));
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _attachments.addAll(result.files.map((file) => {
//               'name': file.name,
//               // 'bytes': file.bytes,
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

//   void _viewAttachment(String filePath) {
//     if (filePath.isNotEmpty) {
//       openFile(context, filePath); // Mở tệp để xem
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("File path not found!")),
//       );
//     }
//   }

//   Future<void> _sendEmail() async {
//     if (_selectedUserId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a recipient.")),
//       );
//       return;
//     }

//     try {
//       List<Map<String, dynamic>> recipientData =
//           _apiService.prepareRecipients(_recipients);

//       // List<MultipartFile> attachmentFiles = await Future.wait(
//       //   _attachments.map((file) async {
//       //     String fileName = file.path.split('/').last;
//       //     return await MultipartFile.fromFile(file.path, filename: fileName);
//       //   }),
//       // );

//       List<MultipartFile> attachmentFiles = await Future.wait(
//         _attachments.map((file) async {
//           // if (file['path'] != null) {
//           String fileName = file['path']!.split('/').last;
//           return await MultipartFile.fromFile(file['path']!,
//               filename: fileName);
//           // }
//           //  else if (file['path'] != null) {
//           //   return MultipartFile.fromBytes(file['path'], filename: file['name']);
//           // } else { throw Exception("Invalid file data"); }
//         }).toList(),
//       );
//       await _apiService.sendEmail(
//         senderId: id!, // Replace with actual sender ID
//         subject: _titleController.text,
//         body: _contentController.text,
//         isDraft: false,
//         recipients: recipientData,
//         attachments: attachmentFiles,
//       );

//       // await _apiService.composeEmail(
//       //   senderId: id!,
//       //   subject: _titleController.text,
//       //   body: _contentController.text,
//       //   isDraft: false,
//       //   recipients: [
//       //     {"userId": _selectedUserId, "type": "TO"}
//       //   ],
//       //   attachments: _attachments.map((file) => File(file['path']!)).toList(),
//       // );
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
//               _searchUsers(value); // Tìm kiếm khi nhập ký tự
//             },
//           ),
//           if (_searchResults.isNotEmpty) // Hiển thị danh sách nếu có kết quả
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
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(user['profilePic'] ?? ""),
//                     ),
//                     title: Text(user['email']),
//                     onTap: () {
//                       _selectUser(user); // Xử lý khi chọn recipient
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _pickFile,
//                 icon: const Icon(Icons.attach_file),
//                 label: const Text('Attach File'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.image),
//                 label: const Text('Attach Image'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           if (_attachments.isNotEmpty)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Attachments:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: _attachments.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     Map<String, String> file = entry.value;
//                     return Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () => _viewAttachment(file['url'] ?? ''),
//                             child: Text(
//                               file['name'] ?? 'Unknown File',
//                               style: const TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: () => _removeAttachment(index),
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.red,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
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
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:final_essays/model/Recipient.dart';
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

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:final_essays/model/CreateRecipientReq.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:final_essays/service/ApiService.dart';
// class EmailComposeScreen extends StatefulWidget {
//   const EmailComposeScreen({Key? key}) : super(key: key);

class ComposeEmailForm extends StatefulWidget {
  @override
  _ComposeEmailFormState createState() => _ComposeEmailFormState();
}

class _ComposeEmailFormState extends State<ComposeEmailForm>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _recipientSearchController =
      TextEditingController();
  String _activeField = "TO"; // Tracks the currently active recipient field
  final List<Map<String, String>> _recipients = [];
  final List<Map<String, String>> _ccRecipients = [];
  final List<Map<String, String>> _bccRecipients = [];

  List<Map<String, dynamic>> _searchResults = [];
  String? _selectedUserId;

  final List<File> _attachments = [];
  bool _isDraft = false;
  bool _showCCBCC = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("Dispose");
    WidgetsBinding.instance.removeObserver(this);
    _sendEmail(isDraft: true);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("App pause");
      _sendEmail(isDraft: true);
    }
  }

  final ApiService _apiService = ApiService();

  Future<void> _searchUsers(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    var results = await _apiService.searchUsers(keyword);
    setState(() {
      _searchResults = results;
    });
  }

  void _addRecipient(String type, Map<String, String> recipient) {
    setState(() {
      if (type == "TO") {
        _recipients.add(recipient);
      } else if (type == "CC") {
        _ccRecipients.add(recipient);
      } else if (type == "BCC") {
        _bccRecipients.add(recipient);
      }
      _recipientSearchController.clear();
    });
  }

  void _removeRecipient(String type, Map<String, String> recipient) {
    setState(() {
      if (type == "TO") {
        _recipients.remove(recipient);
      } else if (type == "CC") {
        _ccRecipients.remove(recipient);
      } else if (type == "BCC") {
        _bccRecipients.remove(recipient);
      }
    });
  }

  void _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachments.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  void _removeAttachment(File file) {
    setState(() {
      _attachments.remove(file);
    });
  }

  Icon _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue);
      case 'txt':
        return const Icon(Icons.text_snippet, color: Colors.grey);
      case 'jpg':
      case 'png':
      case 'jpeg':
        return const Icon(Icons.image, color: Colors.orange);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.black);
    }
  }

  void _sendEmail({bool isDraft = false}) async {
    print("sendEmail called with isDraft: $isDraft");
    // if (_formKey.currentState?.validate() ?? false) {
    List<CreateRecipientReq> allRecipients = [
      ..._recipients.map((r) => CreateRecipientReq(
            userId: r["id"]!, // Assuming userId is email
            type: "TO",
          )),
      ..._ccRecipients.map((r) => CreateRecipientReq(
            userId: r["id"]!,
            type: "CC",
          )),
      ..._bccRecipients.map((r) => CreateRecipientReq(
            userId: r["id"]!,
            type: "BCC",
          )),
    ];

    print(allRecipients.toString());

    // List<MultipartFile> attachments = _attachments
    //     .map((file) {
    //       return MultipartFile.fromFile(file.path,
    //           filename: path.basename(file.path));
    //     })
    //     // .cast<MultipartFile>()
    //     .toList();

    List<MultipartFile> attachments = await Future.wait(
      _attachments.map((file) async {
        String fileName = path.basename(file.path);
        return await MultipartFile.fromFile(file.path, filename: fileName);
      }).toList(),
    );
    print("isDraft $_isDraft");
    try {
      await _apiService.sendEmail(
        subject: _subjectController.text,
        body: _bodyController.text,
        isDraft: isDraft,
        recipients: allRecipients,
        attachments: attachments,
      );
      // Show success message or navigate to another screen
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Email sent successfully!")));
      if (!isDraft) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email sent successfully!")),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error sending email: $e")));
    }
    print("Sending email...");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compose Email"),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendEmail,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecipientField("TO"),
                if (_showCCBCC) _buildRecipientField("CC"),
                if (_showCCBCC) _buildRecipientField("BCC"),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showCCBCC = !_showCCBCC;
                      });
                    },
                    child: Text(_showCCBCC ? "Hide CC/BCC" : "Show CC/BCC"),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: "Subject"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a subject" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: "Body"),
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the email body" : null,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickAttachments,
                  child: const Text("Add Attachments"),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: _attachments.map((file) {
                    final fileName = path.basename(file.path);
                    return Chip(
                      avatar: _getFileIcon(fileName),
                      label: Text(fileName),
                      onDeleted: () => _removeAttachment(file),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isDraft,
                      onChanged: (value) {
                        setState(() {
                          _isDraft = value ?? false;
                        });
                      },
                    ),
                    const Text("Save as Draft"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientField(String type) {
    List<Map<String, String>> selectedRecipients;
    if (type == "TO") {
      selectedRecipients = _recipients;
    } else if (type == "CC") {
      selectedRecipients = _ccRecipients;
    } else {
      selectedRecipients = _bccRecipients;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: type == _activeField ? _recipientSearchController : null,
          decoration: InputDecoration(
            labelText: "$type Recipients",
            suffixIcon: type == _activeField &&
                    _recipientSearchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _recipientSearchController.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onTap: () {
            setState(() {
              _activeField = type;
            });
          },
          onChanged: (keyword) async {
            if (keyword.isNotEmpty) {
              await _searchUsers(keyword);
            } else {
              setState(() {
                _searchResults = [];
              });
            }
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: selectedRecipients.map((recipient) {
            return Chip(
              avatar: recipient["profilePic"] != null &&
                      recipient["profilePic"]!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(recipient["profilePic"]!),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),
              // label: Text(recipient["name"]!),

              label: Text("${recipient["lastName"]} ${recipient["firstName"]}"),
              onDeleted: () => _removeRecipient(type, recipient),
            );
          }).toList(),
        ),
        if (type == _activeField && _recipientSearchController.text.isNotEmpty)
          ..._searchResults.map((user) {
            return ListTile(
              leading:
                  user["profilePic"] != null && user["profilePic"]!.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user["profilePic"]!),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
              // title: Text(user["name"]!),
              title: Text("${user["lastName"]} ${user["firstName"]}"),
              subtitle: Text(user["email"]!),
              onTap: () => _addRecipient(type, {
                // "name": user["name"],
                "firstName": user["firstName"],
                "lastName": user["lastName"],
                "email": user["email"],
                "id": user["id"],
                "profilePic": user["profilePic"] ?? "",
              }),
            );
          }).toList(),
        // })
        // .where((user) => user["name"]!
        //     .toLowerCase()
        //     .contains(_recipientSearchController.text.toLowerCase()))
        // .map((user) {
      ],
    );
  }
}
