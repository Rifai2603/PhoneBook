import 'package:flutter/material.dart';
import 'package:phone_book/utils/contants.dart';

class DeleteAlert extends StatelessWidget {
  const DeleteAlert({
    super.key,
    required this.screenWidth,
    required this.onOkPressed,
  });

  final double screenWidth;
  final VoidCallback onOkPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Contact',
        style: TextStyle(
          fontSize: screenWidth / 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to DELETE this contact!',
        style: TextStyle(
          fontSize: screenWidth / 23,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth / 25),
      ),
      backgroundColor: primary,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: screenWidth / 23,
              color: Colors.blue,
            ),
          ),
        ),
        TextButton(
          onPressed: onOkPressed,
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: screenWidth / 23,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
