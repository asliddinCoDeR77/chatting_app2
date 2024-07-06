import 'package:chat_app/model/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactService {
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      QuerySnapshot querySnapshot = await contactsCollection.get();
      for (var doc in querySnapshot.docs) {
        contacts.add(Contact(
          name: doc['name'],
          phone: doc['phone'],
          id: doc['id'],
        ));
      }
      return contacts;
    } catch (e) {
      print('Error retrieving contacts: $e');
      return [];
    }
  }

  Future<void> addContact(String name, String phone) async {
    try {
      await contactsCollection.add({
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Contact added successfully');
    } catch (e) {
      print('Error adding contact: $e');
    }
  }
}
