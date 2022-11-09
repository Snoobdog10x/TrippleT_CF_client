import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre;
  bool? enabled;
  bool? isPaWField;

  CustomTextField({
    Key? key,
    this.controller,
    this.data,
    this.enabled,
    this.hintText,
    this.isObsecre,
    this.isPaWField,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState(
      controller: controller,
      data: data,
      hintText: hintText,
      isObsecre: isObsecre,
      enabled: enabled,
      isPWField: isPaWField);
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre;
  bool? enabled;
  bool? isPWField;

  _CustomTextFieldState(
      {this.controller,
      this.data,
      this.enabled,
      this.hintText,
      this.isObsecre,
      this.isPWField});

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    if (isPWField!)
      return Container(
        width: MediaQuery.of(context).size.width / 1.3,
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: isObsecre!,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: hintText,
            fillColor: Colors.white70,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            suffixIcon: IconButton(
              icon: Icon(
                isObsecre! ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                setState(() {
                  isObsecre = !isObsecre!;
                });
              },
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
        ),
      );
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          fillColor: Colors.white70,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
