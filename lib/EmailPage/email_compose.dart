

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
  final Function(Map<String, String>)? onDraftSaved; // Callback for saving drafts
  final Map<String, String>? initialDetails; // For pre-filled details (reply/forward)

  ComposeEmailForm({this.onDraftSaved, this.initialDetails});

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
      // Pre-fill fields if initial details are provided
    if (widget.initialDetails != null) {
      _toController.text = widget.initialDetails?['to'] ?? '';
      _titleController.text = widget.initialDetails?['title'] ?? '';
      _contentController.text = widget.initialDetails?['content'] ?? '';
    }
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
class _ComposeEmailFormState extends State<ComposeEmailForm> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Map<String, String>> _attachments = [];
  String _selectedLabel = 'Inbox'; // Default label
  final List<String> _labels = ['Inbox', 'Important'];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if initial details are provided
    if (widget.initialDetails != null) {
      _toController.text = widget.initialDetails?['to'] ?? '';
      _titleController.text = widget.initialDetails?['title'] ?? '';
      _contentController.text = widget.initialDetails?['content'] ?? '';
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
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

  void _viewAttachment(String filePath) {
    if (filePath.isNotEmpty) {
      openFile(context, filePath); // Mở tệp để xem
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File path not found!")),
      );
    }
  }

  void _saveAsDraft() {
    final draft = {
      'to': _toController.text,
      'title': _titleController.text,
      'content': _contentController.text,
      'label': _selectedLabel,
    };

    // Call the onDraftSaved callback if provided
    if (widget.onDraftSaved != null) {
      widget.onDraftSaved!(draft); // Save the draft through the callback
    } else {
      // If no callback is provided, show a fallback message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to save draft!")),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email saved to Drafts!")),
    );
    Navigator.pop(context); // Close the compose form
  }

  Future<bool> _onWillPop() async {
    if (_toController.text.isNotEmpty ||
        _titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty ||
        _attachments.isNotEmpty) {
      final shouldSave = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Email?'),
          content: const Text(
              'You have unsaved changes. Do you want to save this email as a draft?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Discard
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _saveAsDraft();
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      return shouldSave ?? false;
    }
    return true;
  }

  // Validate email
  bool _isEmailValid(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // Submit email
  void _submitEmail() {
    if (_toController.text.isEmpty || !_isEmailValid(_toController.text)) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email sent to ${_toController.text}!")),
    );
    Navigator.pop(context); // Close the compose form
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
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back navigation with discard alert
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compose Email'),
          actions: [
            DropdownButton<String>(
              value: _selectedLabel,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.label),
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLabel = newValue!;
                });
              },
              items: _labels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _toController,
                decoration: InputDecoration(
                  labelText: 'To',
                  border: const OutlineInputBorder(),
                  errorText: errorMessage,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              if (_attachments.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attachments:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _attachments.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> file = entry.value;
                        return GestureDetector(
                          onTap: () => _viewAttachment(file['path'] ?? ''),
                          child: Chip(
                            label: Text(file['name'] ?? 'Unknown File'),
                            onDeleted: () => _removeAttachment(index),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach File'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _submitEmail,
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                  ),
                ],
              ),
            ],
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
