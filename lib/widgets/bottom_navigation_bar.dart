import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

      

    }
    return Container(
      child: CurvedNavigationBar(
        backgroundColor: AppColors.thidasaDarkBlue,
        height: 50,
        color: AppColors.thidasaBlue,
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: AppColors.thidasaLightBlue,
          ),
          Icon(
            Icons.search,
            color: AppColors.thidasaLightBlue,
          ),
          Icon(
            Icons.favorite,
            color: AppColors.thidasaLightBlue,
          ),
          Icon(
            Icons.supervised_user_circle,
            color: AppColors.thidasaLightBlue,
          )
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


