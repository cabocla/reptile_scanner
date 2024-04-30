import 'package:flutter/material.dart';

class QRFloatingActionButton extends StatefulWidget {
  const QRFloatingActionButton({ Key? key }) : super(key: key);

  @override
  State<QRFloatingActionButton> createState() => _QRFloatingActionButtonState();
}

class _QRFloatingActionButtonState extends State<QRFloatingActionButton> {
  late bool qrActive;
  @override
  void initState() {
  qrActive = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return FloatingActionButton(
      onPressed: (){
        setState(() {
          qrActive = !qrActive;
          if(qrActive){
            
          }
        });
      },
       child:qrActive? const Icon(Icons.close,
       ): const Icon(Icons.qr_code),
    );
  }
}