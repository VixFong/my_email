import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'search_screen.dart';

class EmailPage extends StatefulWidget {
  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isComposeButtonExpanded = true;

  // Store starred emails
  List<int> starredEmails = [];

  void onScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse && isComposeButtonExpanded) {
        setState(() {
          isComposeButtonExpanded = false;
        });
      } else if (notification.direction == ScrollDirection.forward && !isComposeButtonExpanded) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Search in mail',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        'P',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[900]),
              child: Row(
                children: [
                  Icon(Icons.email, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Text(
                    'Gmail',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.inbox, color: Colors.redAccent),
              title: Text('Primary'),
              onTap: () {
                // Handle Primary folder navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Starred'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StarredEmailsPage(starredEmails),
                  ),
                );
              },
            ),
            // Other drawer items as needed
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
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'This is a sample email message. Slide to see more...',
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '13:50',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.star,
                          color: starredEmails.contains(index) ? Colors.amber : Colors.grey,
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
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  // Handle compose button click
                },
                child: isComposeButtonExpanded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Compose', style: TextStyle(color: Colors.white)),
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
                  color: Colors.grey[300],
                ),
                Container(
                  height: 56,
                  color: Colors.white,
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
    return Scaffold(
      appBar: AppBar(
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
            title: Text('Shopee'),
            subtitle: Text('This is a starred email message.'),
          );
        },
      ),
    );
  }
}
