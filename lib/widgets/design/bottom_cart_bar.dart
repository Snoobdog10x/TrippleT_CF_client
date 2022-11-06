import 'package:flutter/material.dart';

class BottomCartBar extends StatefulWidget {
  const BottomCartBar({Key? key}) : super(key: key);

  @override
  State<BottomCartBar> createState() => _BottomCartBar();
}

class _BottomCartBar extends State<BottomCartBar> {
  Map<String, double> itemscard = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
