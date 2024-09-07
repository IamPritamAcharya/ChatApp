import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E12),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E12),
        title: Text('Settings', style: TextStyle(color: Colors.grey[300])),
      ),
      body: ListView(
        children: [
          CustomUserHeader(
            imageUrl: 'https://via.placeholder.com/150', // Add logic to get the correct image URL if needed
            userName: globals.currentUserName,
          ),
          SettingsTile(
              icon: Icons.key,
              title: 'Account',
              subtitle: 'Security notifications, change number'),
          SettingsTile(
              icon: Icons.lock,
              title: 'Privacy',
              subtitle: 'Block contacts, disappearing messages'),
          SettingsTile(
              icon: Icons.emoji_people,
              title: 'Avatar',
              subtitle: 'Create, edit, profile photo'),
          SettingsTile(
              icon: Icons.favorite,
              title: 'Favourites',
              subtitle: 'Add, reorder, remove'),
          SettingsTile(
              icon: Icons.chat,
              title: 'Chats',
              subtitle: 'Theme, wallpapers, chat history'),
          SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Message, group & call tones'),
          SettingsTile(
              icon: Icons.data_usage,
              title: 'Storage and data',
              subtitle: 'Network usage, auto-download'),
          SettingsTile(
              icon: Icons.language,
              title: 'App language',
              subtitle: "English (device's language)"),
          SettingsTile(
              icon: Icons.help, title: 'Help', subtitle: 'Help centre, contact us, privacy policy'),
          SettingsTile(icon: Icons.group, title: 'Invite a friend', subtitle: ''),
          SettingsTile(icon: Icons.system_update, title: 'App updates', subtitle: ''),
          Divider(color: Colors.grey[700]),
          SettingsTile(icon: Icons.camera, title: 'Open Instagram', subtitle: '', iconColor: Colors.pink),
          SettingsTile(icon: Icons.facebook, title: 'Open Facebook', subtitle: '', iconColor: Colors.blue),
        ],
      ),
    );
  }
}

class CustomUserHeader extends StatelessWidget {
  final String imageUrl;
  final String userName;

  CustomUserHeader({
    required this.imageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0A0E12),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.qr_code, color: Colors.green, size: 20),
          Icon(Icons.arrow_drop_down, color: Colors.green, size: 24),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
    );
  }
}
