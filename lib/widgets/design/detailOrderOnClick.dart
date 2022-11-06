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

  Container itemsCard(
      String thumnailUrl, String itemName, String itemquantity) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(thumnailUrl),
          ),
          Expanded(
            flex: 9,
            child: ListTile(
              title: Text(
                itemName,
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
              subtitle: Text("x" + itemquantity,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  )),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> showItemData() {
    List<DataRow> datarow = [];
    var itemSum = 0;
    var shippingFee = 19000;
    var total = 0;
    allItem.forEach((element) {
      itemSum += int.parse(element.get('price')) *
          int.parse(quantities![allItem.indexOf(element)]);
      datarow.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              itemsCard(
                element.get("thumbnailUrl"),
                element.get("title"),
                quantities![allItem.indexOf(element)],
              ),
            ),
            DataCell(
              Text(
                element.get("price"),
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    });
    total = shippingFee + itemSum;
    datarow.add(
      DataRow(
        cells: <DataCell>[
          const DataCell(
            Text("Items's sum:"),
          ),
          DataCell(
            Text(itemSum.toString()),
          ),
        ],
      ),
    );
    datarow.add(
      DataRow(
        cells: <DataCell>[
          const DataCell(
            Text('Delivery fee:'),
          ),
          DataCell(
            Text(shippingFee.toString()),
          ),
        ],
      ),
    );
    datarow.add(
      DataRow(
        cells: <DataCell>[
          const DataCell(
            Text('Total:'),
          ),
          DataCell(
            Text(total.toString()),
          ),
        ],
      ),
    );
    return datarow;
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    //return Colors.green; // Use the default value.
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (!allItem.isEmpty) {
      return Container(
        child: DataTable(
          dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Item',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Price',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          rows: showItemData(),
        ),
      );
    }
    return circularProgress();
  }
}
