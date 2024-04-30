import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class QRScanScreen extends StatelessWidget {
  static const routeName = '/scan';
  const QRScanScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pop(context);
      }, child:const Icon(Icons.close),),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(icons: 
       const [Icons.image,
        Icons.code,
        ]
      , activeIndex: 0, onTap: (index){},
        gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      // leftCornerRadius: 32,
      // rightCornerRadius: 32,
      ),
      body:  Container(),
      
    );
  }
}