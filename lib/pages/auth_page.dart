import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reptile_scanner/services/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Auth Page'),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      signIn(auth);
                      isLoading = true;
                      setState(() {});
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign In Anon'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn(Auth auth, {String? email, String? pass}) {
    return auth.signInAnonymously();

    // if (email == null || pass == null) {
    //   return auth.signInAnonymously();
    // } else {
    //   return ;
    // }
  }
}
