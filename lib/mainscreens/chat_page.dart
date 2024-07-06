import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String phoneNumber;

  const ChatScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late CollectionReference _messageCollection;

  @override
  void initState() {
    super.initState();
    final currentUserId = _auth.currentUser!.uid;
    final users = [currentUserId, widget.phoneNumber].join('_');
    _messageCollection =
        _firestore.collection('messages').doc(users).collection('chat');
  }

  void _sendMessage(String text) async {
    try {
      if (text.trim().isEmpty) return;
      await _messageCollection.add({
        'text': text,
        'createdAt': Timestamp.now(),
        'sender': _auth.currentUser!.uid,
      });
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send message: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phoneNumber),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messageCollection
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['text']),
                      subtitle: Text(
                        '${data['createdAt'].toDate()}',
                        style: TextStyle(fontSize: 12),
                      ),
                      // Customize sender display if needed
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
