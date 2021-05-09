import 'dart:async';
import 'dart:io';
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
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Obx(
                        () => CircleAvatar(
                            // ignore: unrelated_type_equality_checks
                            backgroundImage: controller.imagePath == ''
                                ? AssetImage("assets/signup_banner.png")
                                : Image.file(File(controller.imagePath.value))
                                    .image),
                      ),
                      Positioned(
                        right: -12,
                        bottom: 0,
                        child: SizedBox(
                          height: 46,
                          width: 46,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                                side: BorderSide(color: Colors.black)),
                            color: Color(0xFFF5F6F9),
                            onPressed: () {
                              controller.getImagePicker();
                            },
                            child: Image.asset("ic_image_upload.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    onPressed: () async {
                      if (controller.isValid() == true) {
                         controller.signup();
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
