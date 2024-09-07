import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  Future<void> _uploadStatus() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _isLoading = true;
      });

      final user = _auth.currentUser;
      final fileName = '${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('status/$fileName');

      try {
        await ref.putFile(File(image.path));
        final imageUrl = await ref.getDownloadURL();

        await _firestore.collection('status').add({
          'imageUrl': imageUrl,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Schedule status deletion after 24 hours
        Timer(Duration(hours: 24), () async {
          try {
            await ref.delete();
            final snapshot = await _firestore.collection('status')
                .where('imageUrl', isEqualTo: imageUrl)
                .get();
            for (DocumentSnapshot ds in snapshot.docs) {
              await ds.reference.delete();
            }
          } catch (e) {
            // Handle deletion error
            print('Error during status deletion: $e');
          }
        });

        // Refresh the list by updating the state
        setState(() {});
      } catch (e) {
        print('Error uploading status: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload status. Please try again.')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Status')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('status')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var statusDocs = snapshot.data!.docs;

                if (statusDocs.isEmpty) {
                  return Center(child: Text('No statuses found.'));
                }

                return ListView.builder(
                  itemCount: statusDocs.length,
                  itemBuilder: (context, index) {
                    var status = statusDocs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(status['imageUrl']),
                      ),
                      title: Text('Status from ${status['userId']}'),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadStatus,
        child: Icon(Icons.add),
      ),
    );
  }
}
