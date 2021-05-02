import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/UI/Register/register_Binding.dart';
import 'package:mem_vl/UI/Register/register_UI.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
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
                  UI_Helper().getTextField(controller.controller_email, 0, 50,
                      0, 10, "Email", "ic_email.png", false),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Obx(
                      () => TextField(
                        textInputAction: TextInputAction.next,
                        controller: controller.controller_pass,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        obscureText: controller.isHidden.value,
                        decoration: InputDecoration(
                          suffix: InkWell(
                            onTap: () => {
                              controller.togglePassword(),
                            },
                            child: controller.isHidden.value
                                ? Image.asset("ic_pass_off.png")
                                : Image.asset("ic_pass_on.png"),
                          ),
                          labelText: 'Password',
                          prefixIcon: Container(
                              width: 20, child: Image.asset('ic_password.png')),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
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
                        onPressed: () {},
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
