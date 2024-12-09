import 'package:flutter/material.dart';
import 'email_compose.dart';

class DraftPage extends StatelessWidget {
  final List<Map<String, String>> drafts;

  DraftPage(this.drafts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drafts"),
      ),
      body: drafts.isEmpty
          ? Center(
              child: Text("No drafts available."),
            )
          : ListView.builder(
              itemCount: drafts.length,
              itemBuilder: (context, index) {
                final draft = drafts[index];
                return ListTile(
                  title: Text(draft['title'] ?? 'No Title'),
                  subtitle: Text(
                    draft['content'] ?? 'No Content',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Handle opening the draft in ComposeEmailForm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComposeEmailForm(
                          initialDetails: draft, // Pre-fill with draft details
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

