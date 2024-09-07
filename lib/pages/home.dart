import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/pages/Statuspage.dart';
import 'package:whatsapp/pages/bottomnavigatonbar.dart';
import 'package:whatsapp/pages/convo.dart';
import 'package:whatsapp/pages/settings.dart';
// Import your StatusPage here

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'WhatsApp',
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code, color: Colors.grey[300]),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.grey[300]),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[300]),
            onSelected: (String result) {
              switch (result) {
                case 'Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                  break;
                default:
                  _showSnackbar(context, result);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'New group',
                child: Text('New group'),
              ),
              PopupMenuItem<String>(
                value: 'New broadcast',
                child: Text('New broadcast'),
              ),
              PopupMenuItem<String>(
                value: 'Linked devices',
                child: Text('Linked devices'),
              ),
              PopupMenuItem<String>(
                value: 'Starred messages',
                child: Text('Starred messages'),
              ),
              PopupMenuItem<String>(
                value: 'Payments',
                child: Text('Payments'),
              ),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem<String>(
                value: 'Switch accounts',
                child: Text('Switch accounts'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF2A3942),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _selectedIndex == 0 ? _buildChatsList() : StatusPage(), // Toggle between Chats and Status
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: [
          BottomNavigationBarItem(
            icon: CustomBottomNavigationBarItem(
              iconData: Icons.chat,
              label: 'Chats',
              isSelected: _selectedIndex == 0,
              badgeCount: 0, // Example badge count
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavigationBarItem(
              iconData: Icons.update,
              label: 'Status',
              isSelected: _selectedIndex == 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavigationBarItem(
              iconData: Icons.group,
              label: 'Communities',
              isSelected: _selectedIndex == 2,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavigationBarItem(
              iconData: Icons.call,
              label: 'Calls',
              isSelected: _selectedIndex == 3,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _selectedIndex == 0 // Show FAB only on Chats page
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color.fromARGB(255, 0, 175, 102),
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildChatsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users Collection').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var users = snapshot.data!.docs;
        var currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          return Center(child: Text('No user logged in.'));
        }

        var filteredUsers = users.where((user) => user['email'] != currentUser.email).toList();

        if (filteredUsers.isEmpty) {
          return Center(child: Text('No users found.'));
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            var user = filteredUsers[index];

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConvoPage(
                      userName: user['name'],
                      userImage: user['image'],
                      chatId: getChatId(currentUser.email!, user['email']),
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_getDirectImageUrl(user['image'])),
              ),
              title: Text(user['name'], style: TextStyle(color: Colors.white)),
              subtitle: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(getChatId(currentUser.email!, user['email']))
                    .collection('Messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('tap to chat', style: TextStyle(color: Colors.grey));
                  }

                  var lastMessage = snapshot.data!.docs.first['message'];
                  return Text(lastMessage, style: TextStyle(color: Colors.grey));
                },
              ),
            );
          },
        );
      },
    );
  }

  String getChatId(String email1, String email2) {
    return email1.hashCode <= email2.hashCode
        ? '$email1-$email2'
        : '$email2-$email1';
  }

  String _getDirectImageUrl(String url) {
    if (url.contains("drive.google.com")) {
      final uri = Uri.parse(url);
      if (uri.pathSegments.contains("d")) {
        final id = uri.pathSegments[uri.pathSegments.indexOf("d") + 1];
        return "https://drive.google.com/uc?export=view&id=$id";
      }
    }
    return url; // return the original URL if it's not a Google Drive URL
  }
}
