import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:reptile_scanner/models/page_tab_item.dart';
import 'package:reptile_scanner/pages/qr_scan_screen.dart';

class HomeScaffoldAnimated extends StatelessWidget {
  final ValueChanged<int>? onSelectTab;
  final int? currentIndex;

  const HomeScaffoldAnimated({
    Key? key,
    @required this.currentIndex,
    @required this.onSelectTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, QRScanScreen.routeName);
        },
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.task_alt,
          Icons.pets,
          Icons.person,
        ],
        activeIndex: currentIndex!,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        // leftCornerRadius: 32,
        // rightCornerRadius: 32,
        activeColor: theme.primaryColor,
        splashColor: theme.secondaryHeaderColor,
        onTap: (index) {
          onSelectTab!(index);
        },
      ),
      body: _bodyBuilder(context, currentIndex!),
    );
  }

  Widget? _bodyBuilder(BuildContext context, int index) {
    final itemData = PageTabItemData.allTabs.values.toList()[index];
    return itemData.page;
  }
}
