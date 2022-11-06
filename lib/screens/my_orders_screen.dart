import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/global/global.dart';
import 'package:users_food_app/widgets/design/orderDetailAlertDialog.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:users_food_app/widgets/simple_app_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  QuerySnapshot<Map<String, dynamic>>? orderData;
  List<Map<String, dynamic>> itemsByOrder = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("orders")
        .where("orderBy", isEqualTo: sharedPreferences!.getString("uid"))
        .get()
        .then(
      (value) {
        List<Map<String, dynamic>> temp = [];
        value.docs.forEach(
          (element) {
            List<dynamic> productIds = element.get("productIDs");
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
              setState(() {
                temp.add({"items": value, "quantities": quantities});
              });
            });
          },
        );

        setState(
          () {
            itemsByOrder = temp;
            orderData = value;
            // print((temp[0]['items'] as QuerySnapshot<Map<String, dynamic>>)
            //     .docs
            //     .toString());
          },
        );
      },
    );
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

  calculateTotal(allItem, quantities) {
    var itemSum = 0;
    var shippingFee = 19000;
    var total = 0;
    allItem.forEach((element) {
      itemSum += int.parse(element.get('price')) *
          int.parse(quantities![allItem.indexOf(element)]);
    });
    return itemSum + shippingFee + total;
  }

  @override
  Widget build(BuildContext context) {
    if (orderData != null) {
      if (itemsByOrder.length == orderData!.docs.length)
        return Scaffold(
          backgroundColor: Color(0xFFFAC898),
          appBar: SimpleAppBar(
            title: "My Orders",
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
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orderData!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String userId = orderData!.docs[index].get("orderBy");
                String addressId = orderData!.docs[index].get("addressID");
                String status = orderData!.docs[index].get("status");
                String orderId = orderData!.docs[index].get("orderId");
                var timeStamp = orderData!.docs[index].get("orderTime");
                var date = new DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(timeStamp) * 1000);
                return Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Center(
                              child: orderDetailArlertDialog(
                                  status, orderId, userId, addressId),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: AutoSizeText(
                                        status,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: ListTile(
                                title: AutoSizeText("Order Id: " + orderId),
                                subtitle: AutoSizeText(
                                    "Order date: " + date.toString()),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ListTile(
                                title: Text("Total"),
                                subtitle: Text(calculateTotal(
                                        (itemsByOrder[index]['items']
                                                as QuerySnapshot<
                                                    Map<String, dynamic>>)
                                            .docs,
                                        itemsByOrder[index]['quantities'])
                                    .toString()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
    }
    return circularProgress();
  }
}
