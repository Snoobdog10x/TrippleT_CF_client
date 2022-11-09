import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_food_app/global/global.dart';
import 'package:users_food_app/models/users.dart';
import 'package:users_food_app/screens/home_screen.dart';

import '../authentication/login.dart';
import '../widgets/items_avatar_carousel.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var currentUserUID = sharedPreferences!.getString('uid');

  Users? curUser;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? currentUser =
      FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPreferences!.getString("uid")!)
          .snapshots();

  void parseUserData(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    curUser = Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
    displayPhotoUrlController = TextEditingController(text: curUser!.photoUrl);
    displayNameController = TextEditingController(text: curUser!.name);
    displayEmailController = TextEditingController(text: curUser!.email);
    // print(snapshot.data!.data());
  }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController? displayPhotoUrlController;
  TextEditingController? displayNameController;
  TextEditingController? displayEmailController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: currentUser,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          parseUserData(snapshot);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Profile',
              ),
            ),
            body: Container(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.grey,
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(curUser!.photoUrl!),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.photo_camera),
                              onPressed: () {
                                _getImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 30, right: 10),
                    child: TextField(
                      controller: displayNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: curUser!.name,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 30, right: 10),
                    child: TextFormField(
                      controller: displayEmailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: true,
                        // hintText: curUser!.email,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 30, right: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5),
                        labelText: 'Status',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabled: false,
                        hintText: curUser!.status,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            _updateUser(currentUserUID.toString());
                            Fluttertoast.showToast(msg: "Update success!");
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Color(0xFFFAC898),
          appBar: SimpleAppBar(
            title: "Profile",
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(-2.0, 0.0),
                end: FractionalOffset(5.0, -1.0),
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFAC898),
                ],
              ),
            ),
            child: circularProgress(),
          ),
        );
      }),
    );
  }

  void _updateUser(String currentUserUID1) {
    Map<String, String> dataUser = {
      'name': displayNameController!.text,
      'email': displayEmailController!.text
    };
    print(dataUser.toString());
    final collection = FirebaseFirestore.instance.collection('users');
    collection.doc(currentUserUID1).update(dataUser);
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }
}
