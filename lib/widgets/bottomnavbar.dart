import 'package:chat_app/mainscreens/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  List<Widget> screens = [Homepage(), Homepage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff0F1828),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/contact.svg'),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/chat.svg'),
            label: 'Message',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
