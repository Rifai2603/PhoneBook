// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_book/database/db_handler.dart';
import 'package:phone_book/screens/add_contact.dart';
import 'package:phone_book/screens/contact_details.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:phone_book/utils/contants.dart';
import 'package:phone_book/widgets/custom_listview.dart';
import 'package:phone_book/widgets/icons.dart';
import 'package:phone_book/widgets/text_input.dart';

var isSearchOn = false;

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contactList = [];
  List<Contact> searchList = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  void searchFilter(String keywords) {
    if (keywords.isNotEmpty) {
      setState(() {
        searchList = contactList
            .where(
              (element) => element.name.toLowerCase().startsWith(
                    keywords.toLowerCase(),
                  ),
            )
            .toList();
      });
    } else {
      setState(() {
        searchList = contactList;
      });
    }
  }

  Future<void> addContactData(Contact contact) async {
    await DbHandler.instance.insert(contact);
    getAllContacts();
  }

  Future<void> updateContactdata(Contact contact) async {
    await DbHandler.instance.update(contact);
    getAllContacts();
  }

  Future<void> deleteContactdata(String id) async {
    await DbHandler.instance.delete(id);
    getAllContacts();
  }

  //get contacts to display
  Future<void> getAllContacts() async {
    List<Contact> contacts = await DbHandler.instance.getAllContacts();

    setState(() {
      contactList = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 20,
            vertical: screenWidth / 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtons(
                screenHeight: screenHeight,
                onPressed: () async {
                  setState(() {
                    if (!isSearchOn) {
                      searchList = contactList;
                      isSearchOn = true;
                    } else {
                      searchList.clear();
                      searchController.clear(); //clear the 'value' of textFeild
                      isSearchOn = false;
                    }
                  });
                  await getAllContacts();
                },
                icon: isSearchOn
                    ? Icons.cancel_outlined
                    : Icons.manage_search_rounded,
              ),
              !isSearchOn
                  ? Text(
                      'Phone',
                      style: TextStyle(fontSize: screenHeight / 40),
                    )
                  : SearchTextField(
                      searchController: searchController,
                      screenWidth: screenWidth,
                      onChanged: (value) => searchFilter(value),
                      onSubmitted: (value) {
                        setState(() {
                          searchFilter(value);
                          FocusScope.of(context).unfocus();
                          if (searchList.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'No Contact Found!',
                              gravity: ToastGravity.CENTER,
                              fontSize: screenWidth / 28,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        });
                      },
                    ),
              IconButtons(
                icon: Icons.person_add_rounded,
                onPressed: () {
                  if (!isSearchOn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddContact(
                          addContactData: addContactData,
                        ),
                      ),
                    );
                  }
                },
                screenHeight: screenHeight,
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
            child: contactList.isEmpty
                ? Center(
                    child: Text(
                      'No Contacts Found!',
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount:
                        isSearchOn ? searchList.length : contactList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      Contact contact =
                          isSearchOn ? searchList[index] : contactList[index];
                      return CustomListView(
                        screenWidth: screenWidth,
                        iconColor:
                            contact.isFav == 1 ? Colors.red : Colors.white,
                        iconData: contact.isFav == 1
                            ? Icons.star_sharp
                            : Icons.star_border,
                        onIconClicked: () async {
                          contact.isFav = 1;
                          await updateContactdata(contact);
                        },
                        onItemClicked: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactDetails(
                              //this is for contact details page
                              contact: contact,
                              updateContactdata: updateContactdata,
                              deleteContactData: deleteContactdata,
                            ),
                          ),
                        ),
                        //this is for custom listView page
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
