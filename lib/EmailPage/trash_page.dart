import 'package:flutter/material.dart';

class TrashPage extends StatelessWidget {
  final List<Map<String, String>> trashedEmails;
  final Function(Map<String, String>) onRestore;

  TrashPage({required this.trashedEmails, required this.onRestore});

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
                  trailing: IconButton(
                    icon: const Icon(Icons.restore, color: Colors.green),
                    onPressed: () {
                      onRestore(email); 
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}
