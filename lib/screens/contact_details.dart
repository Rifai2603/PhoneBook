// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:phone_book/utils/contants.dart';
import 'package:phone_book/widgets/custom_row.dart';
import 'package:phone_book/widgets/delete_alert.dart';
import 'package:phone_book/widgets/icons.dart';
import 'package:phone_book/widgets/profile_page_components.dart';
import 'package:url_launcher/url_launcher_string.dart';

var isEditingModeOn = false;

class ContactDetails extends StatefulWidget {
  final Contact contact;
  final Future<void> Function(Contact contact)? updateContactdata;
  final Future<void> Function(String id)? deleteContactData;

  const ContactDetails({
    super.key,
    required this.contact,
    this.updateContactdata,
    this.deleteContactData,
  });

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  File? imageFile;
  String? imagePath;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imagePath = widget.contact.photoUrl;
    _nameController.text = widget.contact.name;
    _mobileController.text = widget.contact.mobile;
    _emailController.text = widget.contact.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    if (isEditingModeOn) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          imagePath = pickedFile.path;
          widget.contact.photoUrl = imagePath!;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'No Image selected!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } else {
      return;
    }
  }

  bool updateContact(double screenWidth) {
    if (_nameController.text == '' ||
        _emailController.text == '') {
      Fluttertoast.showToast(
        msg: 'Something is missing...',
        fontSize: screenWidth / 28,
        toastLength: Toast.LENGTH_LONG,
      );

      return false;
    }

    widget.updateContactdata!(widget.contact);

    return true;
  }

  void deleteContact(double screenWidth) {
    if (!isEditingModeOn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteAlert(
            screenWidth: screenWidth,
            onOkPressed: () {
              widget.deleteContactData!(widget.contact.id);
              Navigator.popUntil(context, (route) => route.isFirst);
              Fluttertoast.showToast(
                msg: 'Contact ${widget.contact.name} Deleted!',
                fontSize: screenWidth / 28,
                toastLength: Toast.LENGTH_LONG,
              );
            },
          );
        },
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    onPressed: () {
                      setState(() {
                        isEditingModeOn = false;
                      });
                      Navigator.pop(context);
                    },
                    icon: Icons.arrow_back_ios_new_rounded,
                  ),
                  SizedBox(
                    width: screenWidth / 8,
                  ),
                  IconButtons(
                    screenHeight: screenHeight,
                    onPressed: () {
                      if (isEditingModeOn && updateContact(screenWidth)) {
                        Fluttertoast.showToast(
                          msg: 'Contact ${widget.contact.name} Updated!',
                          gravity: ToastGravity.CENTER,
                          fontSize: screenWidth / 28,
                        );
                        setState(() {
                          isEditingModeOn = false;
                        });
                      } else {
                        setState(() {
                          isEditingModeOn = true;
                        });
                      }
                    },
                    icon: isEditingModeOn ? Icons.save : Icons.edit,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: profilePadding(screenWidth),
                decoration: profileBoxDecoration(screenWidth),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileImage(
                        screenWidth: screenWidth,
                        onTap: () => pickImage(),
                        selectedImageFile: File(widget.contact.photoUrl),
                      ),
                      SizedBox(
                        height: screenWidth / 14,
                      ),
                      !isEditingModeOn
                          ? Text(
                              widget.contact.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth / 15,
                              ),
                            )
                          : TextField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  widget.contact.name = _nameController.text;
                                });
                              },
                            ),
                      SizedBox(
                        height: screenWidth / 14,
                      ),
                      CustomRow(
                        width: screenWidth,
                        backgroundColor: Colors.green,
                        iconData: Icons.call,
                        customWidget: !isEditingModeOn
                            ? GestureDetector(
                                //make a call
                                onTap: () async {
                                  if (!isEditingModeOn) {
                                    final url = 'tel: ${widget.contact.mobile}';
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url);
                                    }
                                  }
                                },
                                child: Text(
                                  widget.contact.mobile,
                                  style: TextStyle(
                                    fontSize: screenWidth / 20,
                                  ),
                                ),
                              )
                            : TextField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Mobile',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    widget.contact.mobile =
                                        _mobileController.text;
                                  });
                                },
                              ),
                      ),
                      SizedBox(
                        height: screenWidth / 14,
                      ),
                      CustomRow(
                        width: screenWidth,
                        backgroundColor: Colors.grey.shade800,
                        iconData: Icons.mail_rounded,
                        customWidget: !isEditingModeOn
                            ? GestureDetector(
                                onTap: () async {
                                  if (!isEditingModeOn) {
                                    final url =
                                        'mailto: ${widget.contact.email}';
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url);
                                    }
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    widget.contact.email,
                                    style: TextStyle(
                                      fontSize: screenWidth / 20,
                                    ),
                                  ),
                                ),
                              )
                            : TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email Address',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    widget.contact.email =
                                        _emailController.text;
                                  });
                                },
                              ),
                      ),
                      SizedBox(
                        height: screenWidth / 14,
                      ),
                      CustomRow(
                        width: screenWidth,
                        backgroundColor: Colors.yellow.shade600,
                        iconData: Icons.message_rounded,
                        customWidget: GestureDetector(
                          onTap: () async {
                            if (!isEditingModeOn) {
                              final url = 'sms: ${widget.contact.mobile}';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              }
                            }
                          },
                          child: Text(
                            'Send a Message',
                            style: TextStyle(
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenWidth / 8,
                      ),
                      DeleteButton(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        onPressed: () => deleteContact(screenWidth),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

