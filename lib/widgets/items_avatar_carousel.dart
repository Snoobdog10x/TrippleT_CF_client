// import 'dart:html';

import 'dart:ffi';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:image_network/image_network.dart';
import 'package:quantity_input/quantity_input.dart';

class ItemsAvatarCarousel extends StatefulWidget {
  const ItemsAvatarCarousel({Key? key}) : super(key: key);

  @override
  State<ItemsAvatarCarousel> createState() => _ItemsAvatarCarouselState();
}

class _ItemsAvatarCarouselState extends State<ItemsAvatarCarousel> {
  Map<String, Map<String, int>> items_list = {};
  int count = 0;
  int cost = 0;
  int simpleIntInput = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("items").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: circularProgress(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.network(document['thumbnailUrl']),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListTile(
                            title: Text(document['title']),
                            subtitle: Text(document['price']),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            onPressed: () {
                              if (items_list[document['itemID']] == null) {
                                items_list[document['itemID']] = {
                                  "quan": 1,
                                  "price": int.parse(document['price'])
                                };
                              } else {
                                items_list[document['itemID']]!['quan'] =
                                    items_list[document['itemID']]!["quan"]! +
                                        1;
                              }
                              setState(() {
                                items_list.values.forEach((element) {
                                  count += element["quan"]!;
                                });
                                cost = 0;
                                items_list.values.forEach((element) {
                                  cost += element["quan"]! * element["price"]!;
                                });
                              });
                              print(cost);
                              print(items_list.toString());
                            },
                            color: Colors.amberAccent,
                            icon: Icon(Icons.add_circle, size: 35),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        color: Colors.white,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('My Cart'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cost = 0;
                            count = 0;
                            items_list = {};
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear Cart',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  body: cart_content(items_list.keys.toList()),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: const Icon(
                          Icons.shopping_cart_rounded,
                          size: 30,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 24,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: Center(
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                    child: Text(
                      cost.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  total_qty(Map<String, int> items_list) {
    var values = items_list.values;
    var result = values.reduce((sum, element) => sum + element);
    return result;
  }

  total_price(Map<String, int> items_list) {
    var keyMapItems = items_list.keys;
    var valuesMapItems = items_list.values;
    int result = 0;

    for (String key in keyMapItems) {
      print(key);
    }
    return result;
  }

  cart_content(List items) {
    if (!items.isEmpty) {
      return Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("items")
              .where(
                'itemID',
                whereIn: items_list.keys.toList(),
              )
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: circularProgress(),
              );
            }
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Image.network(document['thumbnailUrl']),
                            ),
                            Expanded(
                              flex: 4,
                              child: ListTile(
                                title: Text(document['title']),
                                subtitle: Text(document['price']),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        var currentKey = document['itemID'];
                                        var currentItem =
                                            items_list[currentKey];
                                        setState(() {
                                          setState1(() {
                                            if (currentItem!['quan'] == 1) {
                                              items_list.remove(currentKey);
                                            } else {
                                              currentItem['quan'] =
                                                  currentItem['quan']! - 1;
                                            }
                                            cost = cost - currentItem['price']!;
                                            count = count - 1;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(items_list[
                                              document['itemID']]!['quan']
                                          .toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        var currentKey = document['itemID'];
                                        var currentItem =
                                            items_list[currentKey];
                                        setState(() {
                                          setState1(() {
                                            currentItem!['quan'] =
                                                currentItem['quan']! + 1;
                                            cost = cost + currentItem['price']!;
                                            count = count + 1;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      );
    }
    return Container(
      child: Center(
        child: Text('Cart is empty'),
      ),
    );
  }
}
