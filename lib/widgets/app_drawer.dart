import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/page_tab_item.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/pages/about_page.dart';
import 'package:reptile_scanner/pages/colony_list_page.dart';
import 'package:reptile_scanner/pages/dashboard_page.dart';
import 'package:reptile_scanner/pages/feeder_list_page.dart';
import 'package:reptile_scanner/pages/my_pets_page.dart';
import 'package:reptile_scanner/pages/profile_page.dart';
import 'package:reptile_scanner/pages/species_list_page.dart';
import 'package:reptile_scanner/pages/todo_page.dart';
import 'package:reptile_scanner/services/home_page_bloc.dart';

class AppDrawer extends StatelessWidget {
  final String routeName;

  const AppDrawer({
    Key? key,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context, listen: false);
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const CircleAvatar(),
            title: Text(userData.userName),
          ),
          _buildListTile(
            context,
            title: 'Dashboard',
            route: DashboardPage.routeName,
            tabItem: PageTabItem.home,
          ),
          _buildListTile(
            context,
            title: 'My pets',
            route: MyPetsPage.routeName,
            tabItem: PageTabItem.pets,
          ),
          _buildListTile(
            context,
            route: SpeciesListPage.routeName,
            title: 'Species',
          ),
          _buildListTile(
            context,
            route: FeederListPage.routeName,
            title: 'Feeder',
          ),
          _buildListTile(
            context,
            route: ColonyListPage.routeName,
            title: 'Colony',
          ),
          // _buildListTile(
          //   context,
          //   route: BreedingListPage.routeName,
          //   title: 'Breeding',
          // ),
          // _buildListTile(
          //   context,
          //   route: IncubatorListPage.routeName,
          //   title: 'Incubator',
          // ),
          _buildListTile(
            context,
            route: ToDoPage.routeName,
            title: 'To Do',
            tabItem: PageTabItem.todo,
          ),
          _buildListTile(
            context,
            title: 'Profile',
            route: ProfilePage.routeName,
            tabItem: PageTabItem.profile,
          ),

          _buildListTile(
            context,
            route: AboutPage.routeName,
            title: 'About',
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    String title = '',
    Icon? icon,
    required String route,
    PageTabItem? tabItem,
  }) {
    bool isActive = routeName == route;
    Function pushPage = () {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(route);
    };

    if (tabItem != null) {
      pushPage = () {
        Navigator.of(context).pop();
        int index = PageTabItemData.allTabs.keys.toList().indexWhere((element) {
          return element == tabItem;
        });
        HomePageBloc pageBloc =
            Provider.of<HomePageBloc>(context, listen: false);
        //  pageBloc.changeTab(tabItem);
        pageBloc.changeIndex(index);
      };
    }
    Color color = Theme.of(context).primaryColor;
    return ListTile(
      leading: icon,
      title: Text(title),
      tileColor: isActive ? color.withOpacity(0.5) : null,
      onTap: () {
        if (isActive) {
          Navigator.pop(context);
        } else {
          pushPage();
        }
      },
    );
  }
}
