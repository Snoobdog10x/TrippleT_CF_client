// import 'dart:html';

import 'dart:ffi';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/models/items.dart';
import 'package:users_food_app/screens/checkout.dart';
import 'package:users_food_app/widgets/progress_bar.dart';
import 'package:image_network/image_network.dart';
import 'package:quantity_input/quantity_input.dart';

class ItemsAvatarCarousel extends StatefulWidget {
  const ItemsAvatarCarousel({Key? key}) : super(key: key);

  @override
  State<ItemsAvatarCarousel> createState() => _ItemsAvatarCarouselState();
}

class _ItemsAvatarCarouselState extends State<ItemsAvatarCarousel> {
  Map<Items, int> cart = {};
  int count = 0;
  int cost = 0;
  int simpleIntInput = 0;
  List<Items> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseFirestore.instance.collection("items").get().then(
      (value) {
        List<Items> tempItems = [];
        value.docs.forEach(
          (element) {
            tempItems.add(Items.fromJson(element.data()));
          },
        );
        setState(
          () {
            items = tempItems;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return Scaffold(
        body: Container(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var currentItems = items[index];
              var thumnailUrl = items[index].thumbnailUrl;
              var title = items[index].title;
              var price = items[index].price;
              var itemId = items[index].itemID;
              return Container(
                height: MediaQuery.of(context).size.height * 0.12,
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.network(thumnailUrl.toString()),
                      ),
                      Expanded(
                        flex: 5,
                        child: ListTile(
                          title: Text(title.toString()),
                          subtitle: Text("${price.toString()} đ"),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () {
                            if (cart[currentItems] == null) {
                              cart[currentItems] = 1;
                            } else {
                              cart[currentItems] = cart[currentItems]! + 1;
                            }
                            setState(
                              () {
                                count += 1;
                                cost = 0;
                                cart.forEach(
                                  (key, value) {
                                    cost = cost + key.price! * value;
                                  },
                                );
                              },
                            );
                          },
                          color: Colors.amberAccent,
                          icon: Icon(Icons.add_circle, size: 35),
                        ),
                      )
                    ],
                  ),
                ),
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
                              cart = {};
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
                    body: cart_content(),
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
                          right: 25,
                          child: Container(
                            height: 25,
                            width: 25,
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
                  child: ListTile(
                    title: Text(
                      "Total",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      "${cost.toString()} đ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => checkout(cart)),
                        // );
                      },
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
    return circularProgress();
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

  cart_content() {
    if (cart.keys.isNotEmpty) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState1) {
          try {
            return Container(
              child: ListView.builder(
                itemCount: cart.keys.length,
                itemBuilder: (context, index) {
                  var currentItems = cart.keys.toList()[index];
                  var thumnailUrl = currentItems.thumbnailUrl;
                  var title = currentItems.title;
                  var price = currentItems.price;
                  var itemId = currentItems.itemID;
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.network(thumnailUrl.toString()),
                          ),
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              title: Text(title.toString()),
                              subtitle: Text("${price.toString()} đ"),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        setState1(() {
                                          if (cart[currentItems] == 1) {
                                            cart.remove(currentItems);
                                          } else {
                                            cart[currentItems] =
                                                cart[currentItems]! - 1;
                                          }
                                          cost = cost - currentItems.price!;
                                          count = count - 1;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(cart[currentItems].toString()),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        setState1(() {
                                          cart[currentItems] =
                                              cart[currentItems]! + 1;
                                          cost = cost + currentItems.price!;
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
                },
              ),
            );
          } catch (e) {
            return Container(
              child: Center(
                child: Text('Cart is empty'),
              ),
            );
          }
        },
      );
    }
    return Container(
      child: Center(
        child: Text('Cart is empty'),
      ),
    );
  }
}
