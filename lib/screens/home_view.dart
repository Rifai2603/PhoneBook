// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:phone_book/screens/contacts_view.dart';
import 'package:phone_book/screens/favorites_view.dart';
import 'package:phone_book/screens/profile_view.dart';
import 'package:phone_book/utils/contants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    onTap(int index) {
      setState(() {
        pageIndex = index;
      });
    }

    List<Widget> screens = [
      ContactsPage(),
      FavoritesPage(),
      ProfilePage(),
    ];

    return SafeArea(
      child: Scaffold(
        body: screens[pageIndex],
        backgroundColor: primary,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth / 50,
            horizontal: screenWidth / 15,
          ),
          child: GNav(
            backgroundColor: primary,
            gap: 20,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: secondary,
            padding: EdgeInsets.all(screenWidth / 23),
            onTabChange: (index) => onTap(index),
            tabs: [
              GButton(
                icon: Icons.contacts_rounded,
                text: 'Contacts',
              ),
              GButton(
                icon: Icons.star_border_rounded,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.person_rounded,
                text: 'Profile',
              )
            ],
          ),
        ),
      ),
    );
  }
}
