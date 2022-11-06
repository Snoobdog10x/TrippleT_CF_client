import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class checkout extends StatefulWidget {
  Map<String, Map<String, int>> items_list;
  checkout(this.items_list);
  @override
  State<StatefulWidget> createState() => _checkoutState(items_list);
}

class _checkoutState extends State<checkout> {
  Map<String, Map<String, int>> items_list;
  _checkoutState(this.items_list);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
