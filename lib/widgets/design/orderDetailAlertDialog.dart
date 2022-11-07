import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:users_food_app/global/global.dart';
import 'package:users_food_app/widgets/design/detailOrderOnClick.dart';
import 'package:users_food_app/widgets/design/userGetData.dart';

class orderDetailArlertDialog extends StatefulWidget {
  String currentStepText;
  String orderId;
  String userId;
  String addressId;
  orderDetailArlertDialog(
      this.currentStepText, this.orderId, this.userId, this.addressId)
      : super();
  @override
  State<StatefulWidget> createState() =>
      _orderDetailAlertDialogState(currentStepText, orderId, userId, addressId);
}

class _orderDetailAlertDialogState extends State<orderDetailArlertDialog> {
  String currentStepText;
  String orderId;
  String userId;
  String addressId;
  List<String> stepTitles = [
    'Order',
    'Cooking',
    'Shipping',
    'Delivered',
  ];
  getCurrentStepIndex(currentStepText) {
    if (currentStepText == "Order") return 0;
    if (currentStepText == "Cooking") return 1;
    if (currentStepText == "Shipping") return 2;
    if (currentStepText == "Delivered") return 3;
  }

  List<Step> steps = [];
  _orderDetailAlertDialogState(
      this.currentStepText, this.orderId, this.userId, this.addressId);

  @override
  Widget build(BuildContext context) {
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
                activeStep: getCurrentStepIndex(currentStepText),
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
