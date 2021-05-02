import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/UI/Register/register_Controller.dart';
import 'package:mem_vl/Util/UI_Helper.dart';

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
                      createTextField(controller.myController_email, 0, 0, 0,
                          10, "Email", "ic_email.png"),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Obx(
                          () => TextField(
                            textInputAction: TextInputAction.next,
                            controller: controller.myController_pass,
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
                                  width: 20,
                                  child: Image.asset('ic_password.png')),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      UI_Helper().getTextField(controller.myController_name, 0,
                          0, 0, 10, "Name", "ic_name.png", false),
                      UI_Helper().getTextField(controller.myController_phone, 0,
                          0, 0, 25, "Phone number", "ic_phone.png", false)
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: () =>
                        createAlertDialog(context, "Signup status", "Success"),
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

  createTextField(TextEditingController controller, double left, double top,
      double right, double bottom, String labelText, String icon) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: controller,
        style: TextStyle(fontSize: 18, color: Colors.black),
        obscureText: false,
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

  createAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Get.back();
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Meme VL "),
      content: Text("Thanks for signing up!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
