import 'package:flutter/material.dart';

class TrashPage extends StatelessWidget {
  final List<Map<String, String>> trashedEmails;

  TrashPage({required this.trashedEmails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
      ),
      body: trashedEmails.isEmpty
          ? Center(
              child: const Text('No emails in Trash.'),
            )
          : ListView.builder(
              itemCount: trashedEmails.length,
              itemBuilder: (context, index) {
                final email = trashedEmails[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(email['sender']![0].toUpperCase()),
                  ),
                  title: Text(email['title'] ?? 'No Subject'),
                  subtitle: Text(
                    email['content'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
    );
  }
}
