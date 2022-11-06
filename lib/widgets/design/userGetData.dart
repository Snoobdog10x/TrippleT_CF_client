import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../progress_bar.dart';

class userGetData extends StatefulWidget {
  String? userId;
  String? addressId;
  userGetData(this.userId, this.addressId) : super();
  @override
  State<StatefulWidget> createState() => _serGetDataState(userId, addressId);
}

class _serGetDataState extends State {
  String? userId;
  String? addressId;
  DocumentSnapshot<Map<String, dynamic>>? user;
  DocumentSnapshot<Map<String, dynamic>>? address;
  _serGetDataState(this.userId, this.addressId);
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("userAddress")
          .doc(addressId)
          .get()
          .then((value1) {
        setState(() {
          user = value;
          address = value1;
          // print(address!.data().toString());
          // print(user!.data().toString());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (user != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Full name: " + user!.get("name"),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Email: " + user!.get("email"),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Account status: " + user!.get("status"),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Full address: " + address!.get("fullAddress"),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Phone: " + address!.get("phoneNumber"),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return circularProgress();
    }
  }
}
