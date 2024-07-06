import 'package:chat_app/auth/registerpage.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final firebaseservice = AuthFirebaseService();

  login() async {
    final user =
        await firebaseservice.login(emailController.text, passController.text);
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Bottomnavbar(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Login Error"),
            content:
                const Text("Ro'yxatdan o'ting yoki parolingizni tekshiring"),
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
                      return 'Ma`lumot kiriting';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xff2A3C54),
                    filled: true,
                    labelText: 'Emailingizni kiriting',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ma`lumot kiriting';
                    }
                    return null;
                  },
                  controller: passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xff2A3C54),
                    filled: true,
                    labelText: 'Parolingizni kiriting',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(327, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(327, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Registerpage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
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
