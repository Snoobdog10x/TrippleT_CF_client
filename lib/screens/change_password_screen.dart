import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_food_app/global/global.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

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
  TextEditingController currentPasswordController = TextEditingController();

  bool isValidatePW = false;

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
                    'Hi ' + getName.toString() + ' !',
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
                    controller: currentPasswordController,
                    hintText: "Current Password",
                    isObsecre: true,
                  ),
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
                  FlutterPwValidator(
                    controller: newPasswordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    numericCharCount: 3,
                    width: 300,
                    height: 100,
                    onSuccess: () {
                      isValidatePW = true;
                    },
                    onFail: () {
                      isValidatePW = false;
                    },
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
                      var currentPW = currentPasswordController.text.trim();
                      var currentNPW = newPasswordController.text.trim();
                      var currentRNPW = repeatNewPasswordController.text.trim();
                      if (currentNPW == currentRNPW && isValidatePW) {
                        // Huythong1202
                        _changePassword(currentPW, currentNPW).then((value) {
                          if (value) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const LoginScreen(),
                              ),
                            );
                          }
                        });
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

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.
    var user = await FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = await EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "Error changed password!" + error.toString());
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: "Error changed password!" + err.toString());
    });

    return success;
  }

  hello() {
    String s = 'hello';
    return s;
  }
}
