import 'package:flutter/material.dart';
import 'package:users_food_app/global/global.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var getUID = sharedPreferences!.getString('uid');
  var getName = sharedPreferences!.getString('name');

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
            buildListView('Password', '******'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: OutlinedButton(
                    onPressed: () {},
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
                    onPressed: () {},
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

  Widget buildListView(String labelText, String placeholder) {
    return ListView(
      padding: EdgeInsets.only(left: 10, bottom: 30, right: 10),
      children: <Widget>[],
    );
  }
}
