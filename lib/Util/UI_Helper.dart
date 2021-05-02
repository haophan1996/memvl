import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class UI_Helper {
  //Custom My TextField
  getTextField(
      TextEditingController controller,
      double left,
      double top,
      double right,
      double bottom,
      String labelText,
      String icon,
      bool textPass) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: controller,
        style: TextStyle(fontSize: 18, color: Colors.black),
        obscureText: textPass,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Container(width: 20, child: Image.asset(icon)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}
