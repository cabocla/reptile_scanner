import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/models/user_data.dart';
import 'package:reptile_scanner/pages/setting_page.dart';
import 'package:reptile_scanner/widgets/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(routeName: routeName),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingPage.routeName);
              },
            )
          ],
        ),
        body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<UserData>(builder: (context, userData, _) {
      return const Center(
        child: Text('Profile Page'),
      );
    });
  }
}
