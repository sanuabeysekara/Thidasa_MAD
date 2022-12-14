import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../views/your_page.dart';

class NavigationNotifier extends ChangeNotifier{
  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }



}

final naviagetionProvider = ChangeNotifierProvider<NavigationNotifier>((ref) {
  return NavigationNotifier();
});