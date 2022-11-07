// ignore_for_file: file_names, camel_case_types, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../progress_bar.dart';

// ignore: must_be_immutable
class detailOrderOnClick extends StatefulWidget {
  String? orderId;
  detailOrderOnClick(this.orderId) : super();
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _detailOrderOnClickState(orderId);
}

class _detailOrderOnClickState extends State<detailOrderOnClick> {
  String? orderId;
  List<QueryDocumentSnapshot> allItem = [];
  QueryDocumentSnapshot? user;
  _detailOrderOnClickState(this.orderId);
  List<String>? quantities;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get()
        .then((value) {
      List<dynamic> productIds = value.get("productIDs");
      List<String> ids = separateOrderItemIDs(productIds);
      List<String> quantities = separateOrderItemQuantities(productIds);
      FirebaseFirestore.instance
          .collection("items")
          .where("itemID", whereIn: ids)
          // .where("sellerUID",
          //     whereIn: (snapshot.data!.docs[index].data()!
          //         as Map<String, dynamic>)["uid"])
          // .orderBy("publishedDate", descending: true)
          .get()
          .then((value) {
        List<QueryDocumentSnapshot> temp = [];
        for (var element in value.docs) {
          temp.add(element);
        }
        setState(() {
          allItem = temp;
          this.quantities = quantities;
        });
      });
    });
  }

  separateOrderItemIDs(orderIDs) {
    List<String> separateItemIDsList = [], defaultItemList = [];
    int i = 0;

    defaultItemList = List<String>.from(orderIDs);

    for (i; i < defaultItemList.length; i++) {
      //this format => 34567654:7
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");

      //to this format => 34567654
      String getItemId = (pos != -1) ? item.substring(0, pos) : item;

      separateItemIDsList.add(getItemId);
    }

    return separateItemIDsList;
  }

  separateOrderItemQuantities(orderIDs) {
    List<String> separateItemQuantityList = [];
    List<String> defaultItemList = [];
    int i = 0;

    defaultItemList = List<String>.from(orderIDs);

    for (i; i < defaultItemList.length; i++) {
      //this format => 34567654:7
      String item = defaultItemList[i].toString();

      //to this format => 7
      List<String> listItemCharacters = item.split(":").toList();

      //converting to int
      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber.toString());
    }

    return separateItemQuantityList;
  }

  itemsList() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            //                   <--- left side
            color: Colors.black,
            width: 1.0,
          ),
          bottom: BorderSide(

            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        itemCount: allItem.length,
        itemBuilder: (BuildContext context, int index) {
          var itemImg = allItem[index].get("thumbnailUrl");
          var title = allItem[index].get("title");
          var price = allItem[index].get("price");
          var quantity = quantities![index];
          return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.network(itemImg),
                  ),
                  Expanded(
                    flex: 7,
                    child: ListTile(
                      title: Text(
                        title,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        price,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        "x$quantity",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!allItem.isEmpty) {
      return itemsList();
    }
    return circularProgress();
  }
}
