// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_book/database/db_handler.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:phone_book/utils/contants.dart';
import 'package:phone_book/widgets/custom_row.dart';
import 'package:phone_book/widgets/icons.dart';
import 'package:phone_book/widgets/profile_page_components.dart';

class AddContact extends StatefulWidget {
  final Future<void> Function(Contact contact)? addContactData;

  const AddContact({Key? key, this.addContactData}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  File? imageFile;
  String? imagePath;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    } else {
      Fluttertoast.showToast(
        msg: 'No Image selected!',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<bool> saveContactData(double screenWidth) async {
    //generate an 32-bit uuid(unique user id) for the contact
    var rnd = Random().nextInt(0xFFFFFFFF);
    var uuid = rnd.toRadixString(16).padLeft(8, '0');

    String defaultPhotoUrl = 'assets/alt_person.png'; // Gantilah dengan URL default yang sesuai

    Contact contact = Contact(
      id: uuid,
      photoUrl: imagePath ?? defaultPhotoUrl, // Gunakan imagePath jika tidak null, jika null, gunakan defaultPhotoUrl
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      isFav: 0,
    );

    if (_nameController.text == '' || _mobileController.text == '' || _emailController.text == '') {
      Fluttertoast.showToast(
        msg: 'Something is missing...',
        fontSize: screenWidth / 28,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    } else if (!await DbHandler.instance.checkForDuplicate(_nameController.text)) {
      Fluttertoast.showToast(
        msg: 'Contact already exists!',
        fontSize: screenWidth / 28,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }

    widget.addContactData!(contact);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String defaultPhotoUrl = 'assets/alt_person.png';

    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 20,
                vertical: screenWidth / 20,
              ),
              child: Row(
                //header row
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtons(
                    screenHeight: screenHeight,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icons.arrow_back_ios_new_rounded,
                  ),
                  Text(
                    'Add Contact',
                    style: TextStyle(fontSize: screenHeight / 40),
                  ),
                  IconButtons(
                    screenHeight: screenHeight,
                    onPressed: () async {
                      if (await saveContactData(screenWidth)) {
                        Fluttertoast.showToast(
                          msg: 'Contact ${_nameController.text} saved!',
                          gravity: ToastGravity.CENTER,
                          fontSize: screenWidth / 28,
                          toastLength: Toast.LENGTH_LONG,
                        );
                        if (context.mounted) Navigator.pop(context, true);
                      }
                    },
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
            //user data
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
                        selectedImageFile: imageFile,
                      ),
                      SizedBox(
                        height: screenWidth / 10,
                      ),
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: screenWidth / 10,
                      ),
                      CustomRow(
                        width: screenWidth,
                        backgroundColor: Colors.green,
                        iconData: Icons.call,
                        customWidget: TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Mobile',
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenWidth / 15,
                      ),
                      CustomRow(
                        width: screenWidth,
                        backgroundColor: Colors.grey.shade800,
                        iconData: Icons.mail,
                        customWidget: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
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

