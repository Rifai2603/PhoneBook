// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_book/database/db_handler.dart';
import 'package:phone_book/screens/contact_details.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:phone_book/utils/contants.dart';
import 'package:phone_book/widgets/custom_listview.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Contact> favContactList = [];

  @override
  void initState() {
    getFavContacts();
    super.initState();
  }

  Future<void> getFavContacts() async {
    List<Contact> favContacts = await DbHandler.instance.getFavContacts();

    setState(() {
      favContactList = favContacts;
    });
  }

  //get perticular index contact
  void onItemClicked(int index) async {
    final contactId = favContactList[index].id;

    final Contact selectedContact = await DbHandler.instance.search(contactId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetails(contact: selectedContact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth / 20,
            vertical: screenWidth / 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth / 8,
                height: screenWidth / 8.5,
              ),
              Text(
                'Favourites',
                style: TextStyle(fontSize: screenHeight / 40),
              ),
              SizedBox(
                width: screenWidth / 8,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth / 8),
                topRight: Radius.circular(screenWidth / 8),
              ),
            ),
            child: favContactList.isEmpty
                ? Center(
                    child: Text(
                      'No Favourites Added!',
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: favContactList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      Contact contact = favContactList[index];
                      return CustomListView(
                        screenWidth: screenWidth,
                        iconData: Icons.delete_rounded,
                        iconColor: Colors.white,
                        onItemClicked: () => onItemClicked(index),
                        onIconClicked: () async {
                          contact.isFav = 0;
                          Fluttertoast.showToast(
                            msg: '${contact.name} removed from Favorites',
                            gravity: ToastGravity.CENTER,
                            fontSize: screenWidth / 28,
                            toastLength: Toast.LENGTH_LONG,
                          );
                          await DbHandler.instance.update(contact);
                          await getFavContacts();
                        },
                        contact: contact,
                      );
                    }),
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.blueGrey[800],
                        thickness: 1.0,
                        indent: screenWidth / 15,
                        endIndent: screenWidth / 15,
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
