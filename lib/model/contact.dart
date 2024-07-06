import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String phone;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}
