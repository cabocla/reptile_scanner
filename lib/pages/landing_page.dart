import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/pages/auth_page.dart';
import 'package:reptile_scanner/pages/home_page.dart';
import 'package:reptile_scanner/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: Provider.of<Auth>(context).onAuthStateChanged,
        builder: (context, user) {
          if (user.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        });
  }
}
