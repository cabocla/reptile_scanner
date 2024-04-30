import 'package:flutter/material.dart';

class QRIconButton extends StatelessWidget {
  final void Function()? onPressed;
  const QRIconButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code),
      onPressed: onPressed,
    );
  }
}
