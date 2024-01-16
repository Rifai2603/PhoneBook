// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:phone_book/utils/contants.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.screenWidth,
    required this.iconData,
    required this.iconColor,
    required this.onItemClicked,
    required this.onIconClicked,
    required this.contact,
  });

  final double screenWidth;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onItemClicked;
  final VoidCallback onIconClicked;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Material(
      // to clip the splash effect onTap
      color: secondary,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(screenWidth / 8),
        topRight: Radius.circular(screenWidth / 8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onItemClicked,
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth / 18,
          horizontal: screenWidth / 10,
        ),
        leading: SizedBox(
          height: screenWidth / 7,
          width: screenWidth / 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: FileImage(
                  File(contact.photoUrl),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Align(
          alignment: Alignment(-0.5, 0),
          child: Text(
            contact.name,
            style: TextStyle(
              fontSize: screenWidth / 22,
            ),
          ),
        ),
        trailing: SizedBox(
          height: screenWidth / 7,
          width: screenWidth / 7,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              radius: 40,
              onTap: onIconClicked,
              // {
              //   contact.isFav = 1;
              //   updateContact!(contact);
              // },
              splashColor: Colors.grey.withOpacity(0.3),
              child: Icon(
                iconData,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
