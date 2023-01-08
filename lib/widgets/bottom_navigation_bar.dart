import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../views/home_page.dart';
import '../views/save_page.dart';
import '../views/settings_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int index;
  const CustomBottomNavBar(this.index, {Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {




  @override
  Widget build(BuildContext context) {
    int _selectedIndex = widget.index;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (r) => false

        );
      }
      if (index == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SavePage()),
                (r) => false

        );
      }
      if (index == 2) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
                (r) => false
        );
      }

    }
    return BottomNavigationBar(
      selectedItemColor: AppColors.burgundy,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
// BottomNavigationBarItem(
//   icon: Icon(Icons.chat),
//   label: 'Chats',
// ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}


