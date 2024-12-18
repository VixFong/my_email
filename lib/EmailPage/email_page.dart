import 'package:final_essays/model/EmailResponse.dart';
import 'package:final_essays/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart'; // Added import for ThemeProvider
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart'; // Added import for ThemeProvider
import 'search_screen.dart';
import '../SettingPage/setting_page.dart';
import 'email_compose.dart';
import 'detail_email.dart';
import 'draft_page.dart';
import 'starred_emails_page.dart';
import 'trash_page.dart';
import 'archive_page.dart';
import 'package:intl/intl.dart';

class EmailPage extends StatefulWidget {
  final String folder;

  const EmailPage({Key? key, required this.folder}) : super(key: key);
  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isComposeButtonExpanded = true;
  late Future<List<EmailResponse>> _emails;
  List<Map<String, String>> archivedEmails = [];
  int? hoveredIndex;
  String profileImageUrl = '';

  void _updateProfileImage(String imageUrl) {
    setState(() {
      profileImageUrl = imageUrl;
    });
  }

  // List of emails
  List<Map<String, String>> emails = List.generate(
    20,
    (index) => {
      'sender': 'Sender $index',
      'title': 'Subject $index',
      'content': 'This is the content of email $index.',
    },
  ); // Sample emails
  // List<Map<String, String>> archivedEmails = [];
  // int? hoveredIndex;

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(),
      ),
    );
  }

  void archiveEmail(int index) {
    Map<String, String> archivedEmail = emails[index];
    setState(() {
      archivedEmails.add(archivedEmail);
      emails.removeAt(index);
    });

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message archived.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              emails.insert(index, archivedEmail);
              archivedEmails.removeLast();
            });
          },
        ),
      ),
    );
  }

  // Store starred emails
  List<int> starredEmails = [];
  String? email;
  String? profilePic;
  bool? isDetailed;
  @override
  void initState() {
    super.initState();
    loadData();
    _emails = ApiService().viewEmailByFolder(
      isDetailed: false, // Thay đổi tùy theo yêu cầu
      folder: widget.folder,
    );
    // fetchEmails();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      profilePic = prefs.getString('profilePic');
    });
  }

  List<Map<String, String>> drafts = [];
  List<int> selectedEmails = [];
  bool isSelectionMode = false;
  List<Map<String, String>> trashedEmails = [];

  void onScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          isComposeButtonExpanded) {
        setState(() {
          isComposeButtonExpanded = false;
        });
      } else if (notification.direction == ScrollDirection.forward &&
          !isComposeButtonExpanded) {
        setState(() {
          isComposeButtonExpanded = true;
        });
      }
    }
  }

  // Toggle star status
  void toggleStar(int index) {
    setState(() {
      // emails[index].isStarred = !emails[index].isStarred;
    });
  }

  // void toggleStar(int index) {
  //   setState(() {
  //     if (starredEmails.contains(index)) {
  //       starredEmails.remove(index);
  //     } else {
  //       starredEmails.add(index);
  //     }
  //   });
  // }

  // Toggle email selection (Activated on long press or tap in selection mode)
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
  void deleteSelectedEmails() {
    setState(() {
      if (emails.isEmpty || selectedEmails.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No emails to delete!")),
        );
        return;
      }

      // Sort indices in descending order to avoid shifting issues
      selectedEmails.sort((a, b) => b.compareTo(a));

      // Move selected emails to Trash and remove them from the main list
      for (int index in selectedEmails) {
        trashedEmails.add(emails[index]); // Add to trash
        emails.removeAt(index); // Remove from emails
      }

      selectedEmails.clear();
      isSelectionMode = false;

      print("Emails After Deletion: ${emails.length}");
      print("Trashed Emails: ${trashedEmails.length}");
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emails moved to Trash!")),
    );
  }

  //Restore email in trash page
  void restoreEmail(Map<String, String> email) {
    setState(() {
      trashedEmails.remove(email); // Remove from trash
      emails.add(email); // Add back to inbox
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email restored to Inbox!")),
    );
  }

  // Handle email tap (Navigate to details or toggle selection if in selection mode)
  Future<void> handleEmailTap(int index) async {
    if (isSelectionMode) {
      toggleSelection(index);
    } else {
      try {
        List<EmailResponse> emailDetails = await ApiService()
            .viewEmailByFolder(isDetailed: true, folder: 'Inbox');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EmailDetailPage(emailResponse: emailDetails[index]),
          ),
        );
      } catch (e) {
        print("Error loading email details: $e"); // Hiển thị thông báo lỗi
      }
    }
  }

  // Handle email long press to enable selection mode
  void handleEmailLongPress(int index) {
    toggleSelection(index); // Toggle selection on long press
  }

  void showComposeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép cuộn nếu nội dung lớn
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: ComposeEmailForm(
              // onDraftSaved: (draft) {
              //   setState(() {
              //     drafts.add(draft);
              //   });
              // },
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // **Added ThemeProvider**

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeProvider.isDarkMode
          ? Colors.black
          : Colors.white, // **Dark/Light Background**
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        title: isSelectionMode
            ? Text('${selectedEmails.length} selected') // Show selected count
            : const Text('Emails'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: _navigateToSearch,
          ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteSelectedEmails,
            ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArchivePage(archivedEmails: archivedEmails),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrashPage(
                    trashedEmails: trashedEmails, // Pass trashed emails
                    onRestore: restoreEmail, // Pass the restore function
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: themeProvider.isDarkMode
            ? Colors.grey[900]
            : Colors.white, // **Dark/Light Drawer**
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.black
                      : Colors.grey[900]), // **Dark/Light Drawer Header**
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Text(
                    '$email',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.inbox, color: Colors.redAccent),
                    title: Text(
                      'Primary',
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : Colors.black), // **Dark/Light Text**
                    ),
                    onTap: () {
                      // Handle Primary folder navigation
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text(
                      'Starred',
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : Colors.black), // **Dark/Light Text**
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StarredEmailsPage(starredEmails),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.drafts, color: Colors.blue),
                    title: Text(
                      'Drafts',
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : Colors.black), // **Dark/Light Text**
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DraftPage(drafts),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
                color: themeProvider.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey), // **Dark/Light Divider**
            ListTile(
              leading: Icon(Icons.settings,
                  color: themeProvider.isDarkMode
                      ? Colors.grey
                      : Colors.black), // **Dark/Light Settings Icon**
              title: Text(
                'Settings',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : Colors.black), // **Dark/Light Text**
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage(onProfileImageChanged: _updateProfileImage,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white70
                        : Colors.black), // **Dark/Light Text**
              ),
              onTap: () {
                // Handle Logout navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logged out!")),
                );
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),

      //               ScaffoldMessenger.of(context).showSnackBar(
      //                 SnackBar(
      //                   content: const Text('Message archived.'),
      //                   action: SnackBarAction(
      //                     label: 'Undo',
      //                     onPressed: () {
      //                       setState(() {
      //                         emails.insert(index, archivedEmail); // Restore the email
      //                         archivedEmails.removeLast(); // Remove from archives
      //                       });
      //                     },
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: MouseRegion(
      //               onEnter: (_) {
      //                 setState(() {
      //                   hoveredIndex = index;
      //                 });
      //               },
      //               onExit: (_) {
      //                 setState(() {
      //                   hoveredIndex = null;
      //                 });
      //               },
      //               child: GestureDetector(
      //                 onTap: () => handleEmailTap(index),
      //                 onLongPress: () => handleEmailLongPress(index),
      //                 child: Container(
      //                   color: selectedEmails.contains(index)
      //                       ? Colors.blue.withOpacity(0.2)
      //                       : hoveredIndex == index
      //                           ? Colors.grey.withOpacity(0.1)
      //                           : Colors.transparent,
      //                   child: ListTile(
      //                     leading: CircleAvatar(
      //                       backgroundColor: Colors.red,
      //                       child: Text(
      //                         'S',
      //                         style: const TextStyle(color: Colors.white),
      //                       ),
      //                     ),
      //                     title: Text(
      //                       emails[index]['title'] ?? '',
      //                       style: TextStyle(
      //                         color: themeProvider.isDarkMode
      //                             ? Colors.white70
      //                             : Colors.black,
      //                       ),
      //                     ),
      //                     subtitle: Text(
      //                       emails[index]['content'] ?? '',
      //                       style: TextStyle(
      //                         color: themeProvider.isDarkMode
      //                             ? Colors.grey[500]
      //                             : Colors.grey[700],
      //                       ),
      //                       maxLines: 1,
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                     trailing: IconButton(
      //                       icon: Icon(
      //                         Icons.star,
      //                         color: starredEmails.contains(index)
      //                             ? Colors.amber
      //                             : themeProvider.isDarkMode
      //                                 ? Colors.grey
      //                                 : Colors.black,
      //                       ),
      //                       onPressed: () {
      //                         toggleStar(index);
      //                       },
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      body: Stack(
        children: [
          FutureBuilder<List<EmailResponse>>(
            future: _emails, // Future chứa danh sách email
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No emails found in ${widget.folder}',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black,
                    ),
                  ),
                );
              }

              // Dữ liệu email
              List<EmailResponse> emails = snapshot.data!;

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  onScroll(notification);
                  return true;
                },
                child: ListView.builder(
                  itemCount: emails.length,
                  itemBuilder: (context, index) {
                    EmailResponse email = emails[index];
                    String formattedDate =
                        DateFormat('dd/MM HH:mm').format(email.createdAt);
                    return Dismissible(
                      key: ValueKey(email.id),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.archive, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          archivedEmails
                              .add(emails[index] as Map<String, String>);
                          emails.removeAt(index);
                        });

                        // Show Snackbar with Undo option
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Message archived.'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(() {
                                  emails.insert(index,
                                      archivedEmails.last as EmailResponse);
                                  archivedEmails.removeLast();
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoveredIndex = index;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            hoveredIndex = null;
                          });
                        },
                        child: GestureDetector(
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
                                email.senderName,
                                // email.subject,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white70
                                      : Colors.black,
                                  fontWeight: email.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    email.subject,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[500]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    email.preview,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[500]
                                          : Colors.grey[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: email.isStarred
                                          ? Colors.amber
                                          : themeProvider.isDarkMode
                                              ? Colors.grey
                                              : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // email.isStarred = !isStarted;
                                        toggleStar(index);
                                      });
                                    },
                                  ),
                                  Text(
                                    // email.createdAt.toString(),
                                    formattedDate,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[500]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isComposeButtonExpanded ? 140 : 56,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[800], // **Dark/Light Button**
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  showComposeModal(context);
                },
                child: isComposeButtonExpanded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Flexible(
                              child: Text(
                            'Compose',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      )
                    : Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300], // **Dark/Light Divider**
                ),
                Container(
                  height: 56,
                  color: themeProvider.isDarkMode
                      ? Colors.black
                      : Colors.white, // **Dark/Light Footer**
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 24,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '99+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// extension on Map<String, String> {
//   Null get isStarred => null;

//   // bool get isStarred => null;

//   set isStarred(bool isStarred) {}
// }
