// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:phone_book/screens/add_contact.dart';
import 'package:phone_book/screens/contacts_view.dart';
import 'package:phone_book/screens/favorites_view.dart';
import 'package:phone_book/screens/home_view.dart';
import 'package:phone_book/screens/profile_view.dart';
import 'package:phone_book/utils/routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Book',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Nunito',
      ),
      home: HomePage(),
      routes: {
        homePage: (context) => HomePage(),
        contactsPage: (context) => ContactsPage(),
        favoritePage: (context) => FavoritesPage(),
        profilePage: (context) => ProfilePage(),
        addContact: (context) => AddContact(),
      },
    );
  }
}
