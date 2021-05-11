import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class UI_Helper {

  setDialogMessage(String content, bool isTwoGetBack) {
    Get.back();
    Get.defaultDialog(
      title: "Status",
      content: Text(content),
      textConfirm: "Ok",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        Get.back();
        if (isTwoGetBack) Get.back();
      },
    );
  }

  setLoading() {
    Get.defaultDialog(
        content: CircularProgressIndicator(),
        barrierDismissible: false,
        title: "Loading...");
  }

  createTextField(
    TextEditingController controller,
    double left,
    double top,
    double right,
    double bottom,
    String labelText,
    String icon,
    bool setErrorTextBool,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: controller,
        style: TextStyle(fontSize: 18, color: Colors.black),
        obscureText: false,
        decoration: InputDecoration(
          errorText: setErrorTextBool ? " invalid" : null,
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

  createTextFieldPassword(
      TextEditingController controller,
      double left,
      double top,
      double right,
      double bottom,
      String labelText,
      String icon,
      bool isObscureText,
      bool isErrorText,
      Function togglePassword){
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: controller,
        style: TextStyle(fontSize: 18, color: Colors.black),
        obscureText: isObscureText,
        decoration: InputDecoration(
          errorText: isErrorText
              ? " invalid"
              : null,
          suffix: InkWell(
            focusNode: FocusNode(skipTraversal: true),
            onTap: () => togglePassword(),
              child: isObscureText
                ? Image.asset("ic_pass_off.png")
                : Image.asset("ic_pass_on.png"),
          ),
          labelText: labelText,
          prefixIcon: Container(
              width: 20,
              child: Image.asset(icon)),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xffCED0D2), width: 1),
            borderRadius:
            BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}
