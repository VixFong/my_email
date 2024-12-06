import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class StarredEmailsPage extends StatelessWidget {
  final List<int> starredEmails;

  StarredEmailsPage(this.starredEmails);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode
            ? Colors.black
            : Colors.blue, // **Dark/Light AppBar**
        title: Text('Starred Emails'),
      ),
      body: ListView.builder(
        itemCount: starredEmails.length,
        itemBuilder: (context, index) {
          int emailIndex = starredEmails[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(
                'S',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'Shopee',
              style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white70
                      : Colors.black), // **Dark/Light Text**
            ),
            subtitle: Text(
              'This is a starred email message.',
              style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.grey[500]
                      : Colors.grey[700]), // **Dark/Light Text**
            ),
          );
        },
      ),
    );
  }
}
