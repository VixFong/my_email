import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'file_utils.dart';

class ComposeEmailForm extends StatefulWidget {
  final Function(Map<String, String>)? onDraftSaved; // Callback for saving drafts

  ComposeEmailForm({this.onDraftSaved});

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
      openFile(context, filePath);
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
      widget.onDraftSaved!(draft);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email saved to Drafts!")),
    );
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (_toController.text.isNotEmpty ||
        _titleController.text.isNotEmpty ||
        _contentController.text.isNotEmpty ||
        _attachments.isNotEmpty) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Email?'),
              content: const Text(
                  'You have unsaved changes. Do you want to save this email as a draft?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Discard
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    _saveAsDraft();
                    Navigator.pop(context, true); // Save and Exit
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
                decoration: const InputDecoration(
                  labelText: 'Send To',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach File'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Attach Image'),
                  ),
                ],
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
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _viewAttachment(file['path'] ?? ''),
                                child: Text(
                                  file['name'] ?? 'Unknown File',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _removeAttachment(index),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Email sent to ${_toController.text}!")),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
