import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passReController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final firebaseservice = AuthFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ma`lumot kirg`izing';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Emailingizni kirg`izing',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ma`lumot kirg`izing';
                    }
                    return null;
                  },
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: 'Parolingizni kirg`izing',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (passController.text != passReController.text) {
                      return 'Kodlar notog`ri';
                    }
                    return null;
                  },
                  controller: passReController,
                  decoration: InputDecoration(
                    labelText: 'Parolingizni qayta kirg`izing',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(327, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final user = await firebaseservice.register(
                        emailController.text,
                        passController.text,
                      );
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Bottomnavbar();
                            },
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Registration Error"),
                              content: const Text(
                                  "Ro'yxatdan o'tishda xatolik yuz berdi"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
