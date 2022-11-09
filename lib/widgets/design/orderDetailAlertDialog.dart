import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:users_food_app/global/global.dart';
import 'package:users_food_app/widgets/design/detailOrderOnClick.dart';
import 'package:users_food_app/widgets/design/userGetData.dart';

import '../../models/orders.dart';

class orderDetailArlertDialog extends StatefulWidget {
  Orders? order;
  orderDetailArlertDialog(this.order) : super();
  @override
  State<StatefulWidget> createState() =>
      _orderDetailAlertDialogState(this.order);
}

class _orderDetailAlertDialogState extends State<orderDetailArlertDialog> {
  Orders? order;
  List<String> stepTitles = [
    'Order',
    'Cooking',
    'Shipping',
    'Delivered',
  ];
  getCurrentStepIndex() {
    var status = order!.status;
    if (status == "Order") return 0;
    if (status == "Cooking") return 1;
    if (status == "Shipping") return 2;
    if (status == "Delivered") return 3;
  }
  
  List<Step> steps = [];
  _orderDetailAlertDialogState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String orderId = order!.orderId!;
    String userId = order!.orderBy!;
    String addressId = order!.addressID!;
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text("order ID: $orderId"),
        ),
        body: ListView(
          children: [
            Container(
              child: IconStepper(
                icons: [
                  Icon(Icons.shopping_cart),
                  Icon(Icons.restaurant),
                  Icon(Icons.delivery_dining),
                  Icon(Icons.check),
                ],
                activeStep: getCurrentStepIndex(),
                enableNextPreviousButtons: false,
                enableStepTapping: false,
              ),
            ),
            userGetData(userId, addressId),
            detailOrderOnClick(orderId),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(
            child: SizedBox(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Cancel order",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
