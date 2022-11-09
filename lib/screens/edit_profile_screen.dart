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

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var currentUserUID = sharedPreferences!.getString('uid');
  var currentUserName = sharedPreferences!.getString('name');
  var currentUserEmail = sharedPreferences!.getString('email');

  // @override
  // void initState() {
  //   super.initState();
  //   !_getStatus(currentUserUID!).then(
  //     (value) {
  //       setState(() {
  //         currentUserStatus = value;
  //       });
  //     },
  //   );
  // }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController displayPhotoUrlController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController displayEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/chicken-fried-e-commerce.appspot.com/o/users%2F1667552814566?alt=media&token=85f1ffbb-dcd3-4809-a8d1-6c7eb4539547'),
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
                  hintText: currentUserName.toString(),
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
                controller: displayEmailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: currentUserEmail.toString(),
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
                  // hintText: _getStatus(currentUserUID!).toString(),
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
                      if (displayNameController.text.trim() != '' &&
                          displayEmailController.text.trim() != '') {
                        _updateUser(currentUserUID.toString());
                        Fluttertoast.showToast(msg: "Update success!");
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const LoginScreen(),
                          ),
                        );
                      } else if (displayNameController.text.trim() == '' &&
                          displayEmailController.text.trim() != '') {
                        Fluttertoast.showToast(msg: "Name must be fielded !");
                      } else if (displayNameController.text.trim() != '' &&
                          displayEmailController.text.trim() == '') {
                        Fluttertoast.showToast(msg: "Email must be fielded !");
                      } else {
                        Fluttertoast.showToast(msg: "Error !");
                      }
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

  void _updateUser(String currentUserUID1) {
    Map<String, String> dataUser = {
      'name': displayNameController.text,
      'email': displayEmailController.text
    };
    print(dataUser.toString());
    final collection = FirebaseFirestore.instance.collection('users');
    collection.doc(currentUserUID1).update(dataUser);
  }

  _getStatus(String currentUserUID1) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var status = '';
    collection.doc(currentUserUID1).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        status = data['status'];
      }
    });
    return status;
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }
}
