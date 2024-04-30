import 'package:flutter/material.dart';
import 'package:reptile_scanner/pages/dashboard_page.dart';
import 'package:reptile_scanner/pages/my_pets_page.dart';
import 'package:reptile_scanner/pages/profile_page.dart';
import 'package:reptile_scanner/pages/todo_page.dart';

enum PageTabItem {
  home,
  todo,
  profile,
  pets,
}

class PageTabItemData {
  const PageTabItemData(
      {required this.title,
      required this.icon,
      required this.selectedIcon,
      required this.page});
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  static Map<PageTabItem, PageTabItemData> allTabs = {
    PageTabItem.home: const PageTabItemData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_filled,
      title: 'Home',
      page: DashboardPage(),
    ),
    PageTabItem.todo: const PageTabItemData(
        icon: Icons.work_outline,
        selectedIcon: Icons.work,
        title: 'To Do',
        page: ToDoPage()),
    PageTabItem.pets: const PageTabItemData(
        icon: Icons.pets_outlined,
        selectedIcon: Icons.pets,
        title: 'My Pets',
        page: MyPetsPage()),
    PageTabItem.profile: const PageTabItemData(
        icon: Icons.person_outlined,
        selectedIcon: Icons.person,
        title: 'Profile',
        page: ProfilePage()),
  };
}
