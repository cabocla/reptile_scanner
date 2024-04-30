import 'package:flutter/material.dart';
import 'package:reptile_scanner/widgets/app_drawer.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(routeName: routeName),
      appBar: AppBar(),
      body: const Center(
        child: Text('Dashboard Page'),
      ),
    );
  }
}
