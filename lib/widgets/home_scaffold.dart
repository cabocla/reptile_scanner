import 'package:flutter/material.dart';

import '../models/page_tab_item.dart';

class HomeScaffold extends StatelessWidget {
  final PageTabItem? currentTab;
  final ValueChanged<PageTabItem>? onSelectTab;

  const HomeScaffold({
    Key? key,
    @required this.currentTab,
    @required this.onSelectTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double iconSize = theme.iconTheme.size ?? 24;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // selectedFontSize: theme.textTheme.caption.fontSize,
        // unselectedFontSize: theme.textTheme.overline.fontSize,
        // selectedItemColor: theme.secondaryHeaderColor,
        // unselectedItemColor: theme.disabledColor,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildItem(PageTabItem.home, iconSize),
          _buildItem(PageTabItem.todo, iconSize),
          _buildItem(PageTabItem.profile, iconSize),
          _buildItem(PageTabItem.pets, iconSize),
        ],
        currentIndex: getCurrentIndex,
        onTap: (index) {
          onSelectTab!(PageTabItem.values[index]);
        },
      ),
      body: _bodyBuilder(context, currentTab),
    );
  }

  int get getCurrentIndex {
    int index =
        PageTabItem.values.indexWhere((element) => element == currentTab);
    return index;
  }

  Widget? _bodyBuilder(BuildContext context, PageTabItem? tabItem) {
    final itemData = PageTabItemData.allTabs[tabItem];
    return itemData!.page;
  }

  BottomNavigationBarItem _buildItem(PageTabItem tabItem, double iconSize) {
    bool isSelected = PageTabItem.values[getCurrentIndex] == tabItem;
    final itemData = PageTabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.icon,
        size: iconSize * 1.2,
      ),
      activeIcon: Icon(
        itemData.selectedIcon,
        size: iconSize,
      ),
      label: isSelected ? itemData.title : '',
    );
  }
}
