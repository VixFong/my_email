import 'package:final_essays/model/EmailResponse.dart';
import 'package:final_essays/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'email_compose.dart';

class DraftPage extends StatefulWidget {
  final List<Map<String, String>> drafts;

  DraftPage(this.drafts);

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  late Future<List<EmailResponse>> _draftsFuture;
  List<int> selectedEmails = [];
  int? hoveredIndex;
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState(); // Gọi API để lấy danh sách email trong thư mục "Draft"
    _draftsFuture =
        ApiService().viewEmailByFolder(isDetailed: true, folder: 'Draft');
  }

  void handleEmailTap(int index) {
    setState(() {
      if (selectedEmails.contains(index)) {
        selectedEmails.remove(index);
      } else {
        selectedEmails.add(index);
      }
    });
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedEmails.contains(index)) {
        selectedEmails.remove(index);
        if (selectedEmails.isEmpty) {
          isSelectionMode =
              false; // Exit selection mode if no emails are selected
        }
      } else {
        selectedEmails.add(index);
        isSelectionMode = true; // Enter selection mode
      }
    });
  }
    // Delete selected emails (Triggered from the AppBar delete button in selection mode)
  // void deleteSelectedEmails() {
  //   setState(() {
  //     if (emails.isEmpty || selectedEmails.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("No emails to delete!")),
  //       );
  //       return;
  //     }

  //     // Sort indices in descending order to avoid shifting issues
  //     selectedEmails.sort((a, b) => b.compareTo(a));

  //     // Move selected emails to Trash and remove them from the main list
  //     for (int index in selectedEmails) {
  //       trashedEmails.add(emails[index]); // Add to trash
  //       emails.removeAt(index); // Remove from emails
  //     }

  //     selectedEmails.clear();
  //     isSelectionMode = false;

  //     print("Emails After Deletion: ${emails.length}");
  //     print("Trashed Emails: ${trashedEmails.length}");
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Emails moved to Trash!")),
  //   );
  // }

  void handleEmailLongPress(int index) {
    toggleSelection(index); // Toggle selection on long press
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drafts"),
      ),
      body: FutureBuilder<List<EmailResponse>>(
        future: _draftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error loading drafts: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No drafts available."));
          } else {
            final drafts = snapshot.data!;
            return ListView.builder(
              itemCount: drafts.length,
              itemBuilder: (context, index) {
                final email = drafts[index];
                return GestureDetector(
                  onTap: () => handleEmailTap(index),
                  onLongPress: () => handleEmailLongPress(index),
                  child: Container(
                    color: selectedEmails.contains(index)
                        ? Colors.blue.withOpacity(0.2)
                        : hoveredIndex == index
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(
                          email.senderName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        email.subject,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black,
                          fontWeight: email.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        email.preview,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[500]
                              : Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: email.isStarred
                              ? Colors.amber
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            email.isStarred = !email.isStarred;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Drafts"),
//       ),
//       body: widget.drafts.isEmpty
//           ? Center(
//               child: Text("No drafts available."),
//             )
//           : ListView.builder(
//               itemCount: widget.drafts.length,
//               itemBuilder: (context, index) {
//                 final draft = widget.drafts[index];
//                 return ListTile(
//                   title: Text(draft['title'] ?? 'No Title'),
//                   subtitle: Text(
//                     draft['content'] ?? 'No Content',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   onTap: () {
//                     // Handle opening the draft in ComposeEmailForm
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ComposeEmailForm(
//                           // initialDetails: draft, // Pre-fill with draft details
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
