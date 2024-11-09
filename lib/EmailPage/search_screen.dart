import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the main page
          },
        ),
        title: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.black54),
          decoration: InputDecoration(
            hintText: 'Search in mail',
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            // Implement the search functionality here
            print("Searching for: $query"); // Placeholder for search logic
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              children: [
                _buildFilterButton(context, 'Label', _showLabelDialog),
                _buildFilterButton(context, 'From', _showFromDialog),
                _buildFilterButton(context, 'To', _showToDialog),
                _buildFilterButton(context, 'Attachment', _showAttachmentDialog),
                _buildFilterButton(context, 'Date', _showDateDialog),
                _buildFilterButton(context, 'Is unread', _showUnreadDialog),
                _buildFilterButton(context, 'Exclude', _showExcludeDialog),
              ],
            ),
            SizedBox(height: 20),
            // Placeholder for search results or suggestions
            Expanded(
              child: Center(
                child: Text(
                  'No results found', // Placeholder text; update this based on search results
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, Function dialogFunction) {
    return OutlinedButton(
      onPressed: () => dialogFunction(context),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  // Updated Dialog for Label with Icons
  void _showLabelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialogWithIcons(
        context,
        'Label',
        [
          'Starred',
          'Scheduled',
          'Important',
          'Sent',
          'Drafts',
          'All mail',
        ],
        [
          Icons.star,
          Icons.schedule,
          Icons.label_important,
          Icons.send,
          Icons.drafts,
          Icons.all_inbox,
        ],
      ),
    );
  }

  // Updated Dialog for Attachment with Icons
  void _showAttachmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialogWithIcons(
        context,
        'Attachment',
        [
          'Has any attachment',
          'Document',
          'Presentation',
          'Spreadsheet',
          'Image',
          'PDF',
          'Video',
        ],
        [
          Icons.attach_file,
          Icons.description,
          Icons.slideshow,
          Icons.table_chart,
          Icons.image,
          Icons.picture_as_pdf,
          Icons.videocam,
        ],
      ),
    );
  }

  // Original Dialogs for From and To without icons
  void _showFromDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialogWithSuggestions(
        context,
        'From',
        ['kiennong.2211@gmail.com', 'phanthanh@gmail.com', 'support@service.com'],
      ),
    );
  }

  void _showToDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildDialogWithSuggestions(
        context,
        'To',
        ['recipient1@gmail.com', 'contact@service.com', 'info@company.com'],
      ),
    );
  }

  // Placeholder dialogs for other filters
  void _showDateDialog(BuildContext context) {}
  void _showUnreadDialog(BuildContext context) {}
  void _showExcludeDialog(BuildContext context) {}

  // Build dialog with icons for Label and Attachment
  Widget _buildDialogWithIcons(BuildContext context, String title, List<String> options, List<IconData> icons) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                icons[index], // Use corresponding icon for each option
                color: Colors.white,
              ),
              title: Text(
                options[index],
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle selection if needed
              },
            );
          },
        ),
      ),
    );
  }

  // Build dialog with suggestions for From and To without icons
  Widget _buildDialogWithSuggestions(BuildContext context, String title, List<String> suggestions) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a name or email',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            Divider(color: Colors.grey),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggestions',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 150, // Limit the height of the suggestions list to avoid overflow
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
                    title: Text(suggestions[index], style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      // Handle selection if needed
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
