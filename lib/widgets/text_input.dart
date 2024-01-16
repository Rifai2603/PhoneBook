// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:phone_book/utils/contants.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.screenWidth,
    required this.onSubmitted,
    required this.onChanged,
    required this.searchController,
  });

  final double screenWidth;
  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth / 2,
      child: TextField(
        enableInteractiveSelection: true,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: searchController,
        cursorColor: Colors.white,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.name,
        style: TextStyle(
          fontSize: screenWidth / 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        decoration: inputDecor(
          hintText: 'Search Contact',
          screenWidth: screenWidth,
        ),
      ),
    );
  }
}
