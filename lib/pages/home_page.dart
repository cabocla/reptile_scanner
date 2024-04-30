import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/home_page_bloc.dart';
import 'package:reptile_scanner/widgets/home_scaffold_animated.dart';

// import '../widgets/home_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // PageTabItem _currentTab = PageTabItem.plans;

  @override
  void initState() {
    
    // Provider.of<HomePageBloc>(context, listen: false)
    //     .changeTab(PageTabItem.home);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageBloc>(builder: (context, bloc, child) {
      // return HomeScaffold(
      //   currentTab: bloc.currentTabItem,
      //   onSelectTab: bloc.changeTab,
      // );
      return HomeScaffoldAnimated(onSelectTab: bloc.changeIndex, currentIndex: bloc.tabIndex,);
    });
  }

  // void _selectTab(PageTabItem tabItem) {
  //   setState(() {
  //     _currentTab = tabItem;
  //   });
  // }
}
