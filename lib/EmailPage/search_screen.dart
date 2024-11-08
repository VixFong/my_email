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
                _buildFilterButton('Label'),
                _buildFilterButton('From'),
                _buildFilterButton('To'),
                _buildFilterButton('Attachment'),
                _buildFilterButton('Date'),
                _buildFilterButton('Is unread'),
                _buildFilterButton('Exclude'),
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

  Widget _buildFilterButton(String label) {
    return OutlinedButton(
      onPressed: () {
        // Implement filter functionality if needed
      },
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
}
