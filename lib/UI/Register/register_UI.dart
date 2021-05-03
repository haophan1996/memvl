import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/UI/Register/register_Controller.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:mem_vl/Util/UI_Loading.dart';
import 'register_Controller.dart';

class RegisterUI extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277D8)),
        elevation: 0, // Remove Shadow Appbar
      ),
      body: KeyboardDismisser(
        gestures: [GestureType.onTap, GestureType.onVerticalDragDown],
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Image.asset('signup_banner.png', width: 300, height: 150),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 6, 6),
                  child: Text('Wassup New Mem',
                      style:
                          TextStyle(fontSize: 22, color: Color(0xff3333333))),
                ),
                Text('Signup with Meme Vl in simple steps',
                    style: TextStyle(fontSize: 15, color: Color(0xff606470))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: Column(
                    children: <Widget>[
                      Obx(
                        () => UI_Helper().createTextField(
                            controller.myController_email,
                            0,
                            0,
                            0,
                            10,
                            "Email",
                            "ic_email.png",
                            controller.isEmailValid.value),
                      ),
                      Obx(
                        () => UI_Helper().createTextFieldPassword(
                            controller.myController_pass,
                            0,
                            0,
                            0,
                            10,
                            "Password",
                            "ic_password.png",
                            controller.isHidden.value,
                            controller.isPasswordValid.value, () {
                          controller.togglePassword();
                        }),
                      ),
                      Obx(
                        () => UI_Helper().createTextField(
                            controller.myController_name,
                            0,
                            0,
                            0,
                            10,
                            "Name",
                            "ic_name.png",
                            controller.isNameValid.value),
                      ),
                      Obx(
                        () => UI_Helper().createTextField(
                            controller.myController_phone,
                            0,
                            0,
                            0,
                            25,
                            "Phone number",
                            "ic_phone.png",
                            controller.isPhoneValid.value),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: () {
                      if (controller.isValid() == true) {
                        SetDialog().showLoading(context, "Loading");
                        controller.signup();
                        Timer(Duration(seconds: 1), () {
                          Navigator.pop(context);
                          print(controller.isSignupSuccess);
                          SetDialog().createAlertDialog(
                              context,
                              "Signup status",
                              "Success",
                              controller.isSignupSuccess,
                              controller.message);
                        });
                      }
                    },
                    child: Text('Signup',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    color: Color(0xff4fad6e),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: "Already a user? ",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.back();
                            },
                          text: 'Login now',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff3277D8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
