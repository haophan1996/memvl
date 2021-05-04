import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/UI/Main/main_Binding.dart';
import 'package:mem_vl/UI/Main/main_UI.dart';
import 'package:mem_vl/UI/Register/register_Binding.dart';
import 'package:mem_vl/UI/Register/register_UI.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:mem_vl/Util/UI_Loading.dart';
import 'login_Controller.dart';

class LoginUI extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: KeyboardDismisser(
        gestures: [GestureType.onTap, GestureType.onVerticalDragDown],
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            constraints: BoxConstraints.expand(), // full width, full height
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                  ),
                  Image.asset('login_banner.png', width: 300, height: 150),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                    child: Text("Wassup mate!",
                        style:
                            TextStyle(fontSize: 22, color: Color(0xff333333))),
                  ),
                  Text("Login",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470))),
                  Obx(() => UI_Helper().createTextField(
                      controller.controller_email,
                      0,
                      50,
                      0,
                      10,
                      "Email",
                      "ic_email.png",
                      controller.isEmailValid.value)),
                  Obx(
                    () => UI_Helper().createTextFieldPassword(
                        controller.controller_pass,
                        0,
                        0,
                        0,
                        20,
                        "Password",
                        "ic_password.png",
                        controller.isHidden.value,
                        controller.isPasswordValid.value, () {
                      controller.togglePassword();
                    }),
                  ),
                  Container(
                    constraints:
                        BoxConstraints.loose(Size(double.infinity, 30)),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          text: "Forgot password",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff606470)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 140, 0, 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: RaisedButton(
                        onPressed: () {
                          if (controller.isValid() == true) {
                            Get.defaultDialog(
                              content: CircularProgressIndicator(),
                              barrierDismissible: false,
                              title: "Status",
                            );
                            controller.signIn();
                          }
                        },
                        child: Text("Log In",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        color: Color(0xff4fad6e),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: RichText(
                      text: TextSpan(
                        text: "New user? ",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff606470)),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => RegisterUI(),
                                    binding: RegisterBinding());
                              },
                            text: "Sign up new account",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff3277D8),
                            ),
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
      ),
    );
  }
}
