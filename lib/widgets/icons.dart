import 'package:flutter/material.dart';

class IconButtons extends StatelessWidget {
  const IconButtons({
    super.key,
    required this.screenHeight,
    required this.onPressed,
    required this.icon,
  });

  final double screenHeight;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: screenHeight / 28,
        color: Colors.white,
      ),
    );
  }
}
