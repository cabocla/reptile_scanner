import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child:
     Column(children: const[
        Text('Exotic Pet Manager'),
        CircularProgressIndicator(  ),
        Text('Loading...'),
      ],)
    );
  }
}