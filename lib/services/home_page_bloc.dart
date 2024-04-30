import 'package:flutter/material.dart';
import 'package:reptile_scanner/models/page_tab_item.dart';

class HomePageBloc extends ChangeNotifier{
  PageTabItem currentTabItem = PageTabItem.home;
  int tabIndex = 0;

  void changeTab(PageTabItem tabItem) {
    currentTabItem = tabItem;
    notifyListeners( );
  }

  void changeIndex(int index){
    tabIndex = index;
    notifyListeners(  );
  }
}
