// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:users_food_app/global/global.dart';
// import 'package:users_food_app/models/address.dart';
// import 'package:users_food_app/models/items.dart';
// import 'package:users_food_app/screens/address_screen.dart';
// import 'package:users_food_app/widgets/progress_bar.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'home_screen.dart';

// class checkout extends StatefulWidget {
//   checkout();
//   @override
//   State<StatefulWidget> createState() => _checkoutState();
// }

// class _checkoutState extends State<checkout> {
//   Map<Items, int> cart = {};
//   List<Address> userAdrress = [];
//   _checkoutState();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     List<Address> tempAdress = [];
//     Map<Items, int> tempCart = {};
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(sharedPreferences!.getString("uid"))
//         .collection("userAddress")
//         .get()
//         .then((value) {
//       value.docs.forEach((element) {
//         tempAdress.add(Address.fromJson(element.data()));
//       });
//     }).catchError((onError) {});
//     String encodedMap = sharedPreferences!.getString('userCart')!;
//     Map<String, dynamic> decodedMap = json.decode(encodedMap);
//     QuerySnapshot<Map<String, dynamic>>? tempItems;
//     FirebaseFirestore.instance
//         .collection("items")
//         .where("itemID", whereIn: decodedMap.keys.toList())
//         .get()
//         .then(
//       (value) {
//         tempItems = value;
//       },
//     );
//     tempItems!.docs.forEach((element) {
//       Items item = Items.fromJson(element.data());
//       tempCart[item] = decodedMap[item.itemID];
//     });
//     setState(() {
//       userAdrress = tempAdress;
//       cart = tempCart;
//     });
//   }

//   getDefaultAddress() {
//     Address? defaultAddress;
//     userAdrress.forEach((element) {
//       if (element.isDefault!) {
//         defaultAddress = element;
//       }
//     });
//     return defaultAddress;
//   }

//   addressChooser() {
//     Address? defaultAddress = getDefaultAddress();
//     if (defaultAddress != null) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.18,
//         child: InkWell(
//           onTap: () {},
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 9,
//                 child: ListTile(
//                   leading: Icon(Icons.location_on),
//                   title: Text(
//                     "Your delivery address",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   subtitle: Text(
//                     addressString,
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Icon(Icons.arrow_forward_ios),
//               ),
//             ],
//           ),
//         ),
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: Colors.black,
//               width: 1.0,
//             ),
//             bottom: BorderSide(
//               color: Colors.black,
//               width: 3.0,
//             ),
//           ),
//         ),
//       );
//     }
//     if (defaultAddress == null) {
//       if(userAdrress==null){
        
//       }
//     }
//     // } catch (e) {
//     //   Fluttertoast.showToast(msg: "Add new address befor checkout");
//     //   WidgetsBinding.instance!.addPostFrameCallback((_) {
//     //     Navigator.pushReplacement(
//     //         context, MaterialPageRoute(builder: (_) => AddressScreen()));
//     //   });
//     // return circularProgress();
//   }

//   itemsList() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.25,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("items")
//             .where("itemID", whereIn: items_list.keys.toList())
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: circularProgress(),
//             );
//           }
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               return Container(
//                 height: MediaQuery.of(context).size.height * 0.25,
//                 child: Card(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Image.network(document['thumbnailUrl']),
//                       ),
//                       Expanded(
//                         flex: 7,
//                         child: ListTile(
//                           title: Text(document['title'],
//                               style: TextStyle(fontSize: 20)),
//                           subtitle: Text(document['price'],
//                               style: TextStyle(fontSize: 20)),
//                           trailing: Text(
//                             "x${items_list[document["itemID"]]!["quan"].toString()}",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }

//   chooseDeliveryDetail() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.18,
//       child: InkWell(
//         onTap: () {},
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Text(
//                   "Choose Delivery method (click it)",
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.amber,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 8,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 9,
//                     child: ListTile(
//                       leading: Icon(Icons.delivery_dining),
//                       title: Text(
//                         "TrippleT delivery",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       subtitle: Text(
//                         "TTTD",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                       trailing: Text(
//                         "19000 đ",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Icon(Icons.arrow_forward_ios),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Colors.black,
//             width: 1.0,
//           ),
//           bottom: BorderSide(
//             color: Colors.black,
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }

//   choosePaymentDetail() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.18,
//       child: InkWell(
//         onTap: () {},
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Text(
//                   "Choose payment method (click it)",
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.amber,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 8,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 9,
//                     child: ListTile(
//                       leading: Icon(Icons.payment),
//                       title: Text(
//                         "Cash on Delivery",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       subtitle: Text(
//                         "COD",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Icon(Icons.arrow_forward_ios),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Colors.black,
//             width: 1.0,
//           ),
//           bottom: BorderSide(
//             color: Colors.black,
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Future writeOrderDetails(Map<String, dynamic> data) async {
//     await FirebaseFirestore.instance
//         .collection("orders")
//         .doc(orderId)
//         .set(data);
//   }

//   getCartToString() {
//     List<String> cartStringList = [];
//     items_list.forEach((key, value) {
//       cartStringList.add("${key}:${value["quan"]}");
//     });
//     return cartStringList;
//   }

//   calculateTotal() {
//     var ship = 19000;
//     var items = 0;
//     items_list.forEach((key, value) {
//       items = items + value["price"]! * value["quan"]!;
//     });
//     return ship + items;
//   }

//   getAdressId() {
//     return userAdress!.docs.toList()[choice_Adress].id;
//   }

//   addOrderDetails() {
//     writeOrderDetails({
//       "addressID": getAdressId(),
//       "totalAmount": calculateTotal().toString(),
//       "orderBy": sharedPreferences!.getString("uid"),
//       "productIDs": getCartToString(),
//       "paymentDetails": "Cash on Delivery",
//       "orderTime": orderId,
//       "isSuccess": true,
//       "status": "Order",
//       "orderId": orderId,
//     }).whenComplete(() {
//       setState(() {
//         orderId = "";
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(),
//           ),
//         );
//         Fluttertoast.showToast(msg: "Order has been placed.");
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (items_list.isNotEmpty && userAdress != null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Checkout"),
//         ),
//         body: ListView(
//           children: [
//             addressChooser(),
//             itemsList(),
//             chooseDeliveryDetail(),
//             choosePaymentDetail(),
//           ],
//         ),
//         bottomNavigationBar: Container(
//           height: MediaQuery.of(context).size.height * 0.08,
//           color: Colors.white,
//           child: InkWell(
//             onTap: () {},
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 5,
//                     child: Container(
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.black, fontSize: 20),
//                         textAlign: TextAlign.center,
//                       ),
//                     )),
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: double.infinity,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent,
//                         padding: EdgeInsets.zero,
//                       ),
//                       onPressed: () {
//                         addOrderDetails();
//                       },
//                       child: const Text(
//                         'Order',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//     if (items_list.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Checkout"),
//         ),
//         body: Center(
//           child: Text("Cart is empty"),
//         ),
//         bottomNavigationBar: Container(
//           height: MediaQuery.of(context).size.height * 0.08,
//           color: Colors.white,
//           child: InkWell(
//             onTap: () {},
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 5,
//                     child: Container(
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.black, fontSize: 20),
//                         textAlign: TextAlign.center,
//                       ),
//                     )),
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     height: double.infinity,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent,
//                         padding: EdgeInsets.zero,
//                       ),
//                       onPressed: () {},
//                       child: const Text(
//                         'Order',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Checkout"),
//       ),
//       body: circularProgress(),
//       bottomNavigationBar: Container(
//         height: MediaQuery.of(context).size.height * 0.08,
//         color: Colors.white,
//         child: InkWell(
//           onTap: () {},
//           child: Row(
//             children: [
//               Expanded(
//                   flex: 5,
//                   child: Container(
//                     child: Text(
//                       "",
//                       style: TextStyle(color: Colors.black, fontSize: 20),
//                       textAlign: TextAlign.center,
//                     ),
//                   )),
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   height: double.infinity,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       padding: EdgeInsets.zero,
//                     ),
//                     onPressed: () {},
//                     child: const Text(
//                       'Order',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
