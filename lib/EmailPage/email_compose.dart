import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'file_utils.dart';

class ComposeEmailForm extends StatefulWidget {
  final Function(Map<String, String>)? onDraftSaved; // Callback for saving drafts
  final Map<String, String>? initialDetails; // For pre-filled details (reply/forward)

  ComposeEmailForm({this.onDraftSaved, this.initialDetails});

  @override
  _ComposeEmailFormState createState() => _ComposeEmailFormState();
}

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
        _attachments.addAll(result.files.map((file) => {
              'name': file.name,
              'path': file.path ?? '',
            }));
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _attachments.addAll(result.files.map((file) => {
              'name': file.name,
              'path': file.path ?? '',
            }));
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _viewAttachment(String filePath) {
    if (filePath.isNotEmpty) {
      openFile(context, filePath); // File viewing functionality
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
}
