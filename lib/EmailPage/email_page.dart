import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart'; // Added import for ThemeProvider
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart'; // Added import for ThemeProvider
import 'search_screen.dart';
import '../SettingPage/setting_page.dart';
import 'email_compose.dart';

class EmailPage extends StatefulWidget {
  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isComposeButtonExpanded = true;

  // Store starred emails
  List<int> starredEmails = [];
  String? email;
  String? profilePic;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      profilePic = prefs.getString('profilePic');
    });
  }

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
      if (starredEmails.contains(index)) {
        starredEmails.remove(index);
      } else {
        starredEmails.add(index);
      }
    });
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
          child: ComposeEmailForm(),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: themeProvider.isDarkMode
              ? Colors.black
              : Colors.white, // **Dark/Light AppBar**
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[200], // **Dark/Light Search Box**
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black), // **Dark/Light Menu Icon**
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Search in mail',
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white70
                              : Colors.black54, // **Dark/Light Text**
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor:
                          themeProvider.isDarkMode ? Colors.grey : Colors.blue,
                      backgroundImage:
                          NetworkImage(profilePic!), // **Dark/Light Avatar**
                      // child: Text(
                      //   'P',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
                  MaterialPageRoute(builder: (context) => SettingsPage()),
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
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              onScroll(notification);
              return true;
            },
            child: ListView.builder(
              itemCount: 20, // Example email count
              itemBuilder: (context, index) {
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
                    'This is a sample email message. Slide to see more...',
                    style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[700]), // **Dark/Light Text**
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '13:50',
                        style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.grey[500]
                                : Colors.grey[700]), // **Dark/Light Text**
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.star,
                          color: starredEmails.contains(index)
                              ? Colors.amber
                              : themeProvider.isDarkMode
                                  ? Colors.grey
                                  : Colors.black, // **Dark/Light Icon**
                        ),
                        onPressed: () {
                          toggleStar(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
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

class StarredEmailsPage extends StatelessWidget {
  final List<int> starredEmails;

  StarredEmailsPage(this.starredEmails);

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // **Added ThemeProvider**
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
