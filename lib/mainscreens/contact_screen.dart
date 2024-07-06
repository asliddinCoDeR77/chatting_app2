import 'package:chat_app/mainscreens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/model/contact.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _addContact(String name, String phone) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('contacts')
          .add({
        'name': name,
        'phone': phone,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact added successfully'),
        ),
      );
      nameController.clear();
      phoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add contact: $e'),
        ),
      );
    }
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _addContact(nameController.text, phoneController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Contact'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _showAddContactDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('contacts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/icons/start.png'),
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No contacts available',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }
          final contacts = snapshot.data!.docs
              .map((doc) => Contact.fromFirestore(doc))
              .toList();
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(
                  contact.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  contact.phone,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.chat, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(phoneNumber: contact.phone),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
