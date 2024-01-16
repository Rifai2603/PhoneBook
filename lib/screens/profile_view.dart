// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_book/utils/contants.dart';
import 'package:phone_book/widgets/custom_row.dart';
import 'package:phone_book/widgets/icons.dart';
import 'package:phone_book/widgets/profile_page_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

var isEditingModeOn = false;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  File? imageFile;
  String? imagePath;

  @override
  void initState() {
    getParentData();
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
    if (isEditingModeOn) {
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

      saveParentData();
    } else {
      return;
    }
  }

  void getParentData() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final photoPath = sharedPreference.getString('photo');
    final name = sharedPreference.getString('name');
    final mobile = sharedPreference.getString('mobile');
    final email = sharedPreference.getString('email');
    setState(() {
      if (photoPath != null) {
        imagePath = photoPath;
        imageFile = File(photoPath);
      }
      _nameController.text = name ?? 'Alen';
      _mobileController.text = mobile ?? '1234567890';
      _emailController.text = email ?? 'alen@example.com';
    });
  }

  void saveParentData() async {
    final sharedPreference = await SharedPreferences.getInstance();

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Something is missing...',
        toastLength: Toast.LENGTH_LONG,
      );
    }
    else {
      await sharedPreference.setString('photo', imagePath!);
      await sharedPreference.setString('name', _nameController.text);
      await sharedPreference.setString('mobile', _mobileController.text);
      await sharedPreference.setString('email', _emailController.text);
    }
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
            //header row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth / 8,
              ),
              Text(
                'Profile',
                style: TextStyle(fontSize: screenHeight / 40),
              ),
              IconButtons(
                screenHeight: screenHeight,
                onPressed: () {
                  setState(() {
                    if (isEditingModeOn) {
                      saveParentData();
                      isEditingModeOn = false;
                    } else {
                      isEditingModeOn = true;
                    }
                  });
                },
                icon: isEditingModeOn ? Icons.save : Icons.edit,
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
                  !isEditingModeOn
                      ? ParentNameText(
                          nameController: _nameController,
                          screenWidth: screenWidth,
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
                              saveParentData();
                            });
                          },
                        ),
                  SizedBox(
                    height: screenWidth / 10,
                  ),
                  CustomRow(
                    width: screenWidth,
                    backgroundColor: Colors.green,
                    iconData: Icons.call,
                    customWidget: isEditingModeOn
                        ? TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Mobile',
                            ),
                            onChanged: (value) {
                              setState(() {
                                saveParentData();
                              });
                            },
                          )
                        : Text(
                            _mobileController.text,
                            style: TextStyle(fontSize: screenWidth / 20),
                          ),
                  ),
                  SizedBox(
                    height: screenWidth / 15,
                  ),
                  CustomRow(
                    width: screenWidth,
                    backgroundColor: Colors.grey.shade800,
                    iconData: Icons.mail,
                    customWidget: isEditingModeOn
                        ? TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                            ),
                            onChanged: (value) {
                              setState(() {
                                saveParentData();
                              });
                            },
                          )
                        : FittedBox(
                            child: Text(
                              _emailController.text,
                              style: TextStyle(fontSize: screenWidth / 20),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
