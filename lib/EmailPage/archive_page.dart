import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  final List<Map<String, String>> archivedEmails;

  ArchivePage({required this.archivedEmails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Emails'),
      ),
      body: archivedEmails.isEmpty
          ? Center(
              child: const Text('No emails in Archive.'),
            )
          : ListView.builder(
              itemCount: archivedEmails.length,
              itemBuilder: (context, index) {
                final email = archivedEmails[index];
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
