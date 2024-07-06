import 'package:chat_app/auth/signinpage.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset('assets/icons/start.png'),
          ),
          const Text(
            '  Connect easily with\nyour family and friends\n       over countries',
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(
            height: 150,
          ),
          const Text(
            'Terms & Privacy Policy',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          FilledButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(327, 52)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Signinpage(),
                ));
              },
              child: const Text(
                'Start Messaging',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ))
        ],
      ),
    );
  }
}
