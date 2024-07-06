import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  final String phoneNumber;

  const ChatScreen({super.key, required this.phoneNumber});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _getFCMToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('DASTURDA VAQTIMIZ KELDI');
      print('XABAR: ${message.data}');

      if (message.notification != null) {
        print('XABARDAGI ASOSIY MA\'LUMOT: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("ORQA FONDAN DASTURGA KIRIB KELDIM");
    });
  }

  void _getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    print("ORQA FONDA XABAR KELDI: ${message.messageId}");
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final user = auth.currentUser;
    if (user == null) return;

    final chatDoc = firestore.collection('chats').doc();
    await chatDoc.set({
      'from': user.uid,
      'to': widget.phoneNumber,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
    _autoReply(text);
  }

  void _autoReply(String userMessage) async {
    String autoReplyText = 'Xabaringiz qabul qilindi. Tez orada javob beramiz.';

    if (userMessage.toLowerCase().contains('salom')) {
      autoReplyText = 'Salom!';
    } else if (userMessage.toLowerCase().contains('nima gap')) {
      autoReplyText = 'Tinch.';
    } else if (userMessage.toLowerCase().contains('isming nima')) {
      autoReplyText = 'Asliddin.';
    } else if (userMessage.toLowerCase().contains('bo`pti xayr')) {
      autoReplyText = 'Xayr';
    }

    final user = auth.currentUser;
    if (user == null) return;

    await Future.delayed(Duration(seconds: 6));

    if (autoReplyText.isNotEmpty) {
      await firestore.collection('chats').add({
        'from': widget.phoneNumber,
        'to': user.uid,
        'text': autoReplyText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with ${widget.phoneNumber}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chats')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final messages = snapshot.data!.docs.where((doc) {
                  final from = doc['from'];
                  final to = doc['to'];
                  final currentUser = auth.currentUser!.uid;

                  return (from == currentUser && to == widget.phoneNumber) ||
                      (from == widget.phoneNumber && to == currentUser);
                }).toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByCurrentUser =
                        message['from'] == auth.currentUser!.uid;

                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? Colors.blueAccent
                              : Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          message['text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
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
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _sendMessage(messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
