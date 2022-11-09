import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_food_app/global/global.dart';

import '../authentication/login.dart';
import '../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var getUID = sharedPreferences!.getString('uid');
  var getName = sharedPreferences!.getString('name');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change Password',
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
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: Container(
                child: Center(
                  child: Text(
                    'Hello ' + getName.toString() + ' !',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.password,
                    controller: newPasswordController,
                    hintText: "New Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.password,
                    controller: repeatNewPasswordController,
                    hintText: "Repeat New Password",
                    isObsecre: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: ElevatedButton(
                    onPressed: () {
                      var currentNPW = newPasswordController.text.trim();
                      var currentRNPW = repeatNewPasswordController.text.trim();
                      if (currentNPW == currentRNPW && currentNPW.length >= 8) {
                        _changePassword(currentNPW);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const LoginScreen(),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(msg: "Error changed password!");
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(String password) async {
//Create an instance of the current user.
    User user = await FirebaseAuth.instance.currentUser!;
//Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      Fluttertoast.showToast(msg: "Successfully changed password!");
      // Alert show_hide
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error changed password!" + error.toString());
    });
  }
}
