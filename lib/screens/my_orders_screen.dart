import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/global/global.dart';
import 'package:users_food_app/widgets/design/orderDetailAlertDialog.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:users_food_app/widgets/simple_app_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/orders.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Orders> userOrders = [];
  Future<void> _reloadUserOrderData() async {
    List<Orders> userOrders = [];
    await FirebaseFirestore.instance
        .collection("orders")
        .where("orderBy", isEqualTo: sharedPreferences!.getString("uid"))
        .get()
        .then(
      (value) {
        value.docs.forEach(
          (element) {
            Orders currentOrder = Orders.fromJson(element.data());
            userOrders.add(currentOrder);
          },
        );
        setState(() {
          this.userOrders = userOrders;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reloadUserOrderData().then((value) => null);
  }

  // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224

  @override
  Widget build(BuildContext context) {
    if (userOrders.isNotEmpty) {
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
          child: RefreshIndicator(
            onRefresh: _reloadUserOrderData,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: userOrders.length,
              itemBuilder: (BuildContext context, int index) {
                Orders currentOrder = userOrders![index];
                String userId = sharedPreferences!.getString('uid')!;
                String addressId = currentOrder.addressID!;
                String status = currentOrder.status!;
                String orderId = currentOrder.orderId!;
                String timeStamp = currentOrder.orderTime!;
                var date = new DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(timeStamp) * 1000);
                var total = currentOrder.totalAmount;
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
                              child: orderDetailArlertDialog(currentOrder),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
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
                                subtitle:
                                    AutoSizeText("Date: " + date.toString()),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: ListTile(
                                title: Text("Total"),
                                subtitle: Text("${total} đ"),
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
        ),
      );
    } else {
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
          child: RefreshIndicator(
            onRefresh: _reloadUserOrderData,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: userOrders.length,
              itemBuilder: (BuildContext context, int index) {
                Orders currentOrder = userOrders![index];
                String userId = sharedPreferences!.getString('uid')!;
                String addressId = currentOrder.addressID!;
                String status = currentOrder.status!;
                String orderId = currentOrder.orderId!;
                String timeStamp = currentOrder.orderTime!;
                var date = new DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(timeStamp) * 1000);
                var total = currentOrder.totalAmount;
                return Container(
                  child: Center(
                    child: Text("Your dont have any order"),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
