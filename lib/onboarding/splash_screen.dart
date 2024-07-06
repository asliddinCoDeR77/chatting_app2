import 'package:chat_app/onboarding/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: SvgPicture.asset(
                      'assets/icons/chat.svg',
                      color: Colors.white,
                      height: 150,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Canterbury',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Powered by asliddincoder',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
