import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xff0F1828),
        appBarTheme: const AppBarTheme(
          color: Color(0xff0F1828),
        ),
        textTheme: GoogleFonts.mulishTextTheme(),
      ),
      dark: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xff1A1A2E),
        appBarTheme: const AppBarTheme(
          color: Color(0xff0F1828),
        ),
        textTheme: GoogleFonts.mulishTextTheme(),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
