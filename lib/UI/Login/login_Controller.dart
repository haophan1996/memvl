import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/UI/DashBoard/dashBoard_Binding.dart';
import 'package:mem_vl/UI/DashBoard/dashBoard_UI.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find<LoginController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final storage = new FlutterSecureStorage();
  SharedPreferences prefs;
  RxBool isCheckBoxRemember = false.obs;
  RxBool isHidden = true.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  final controller_email = TextEditingController();
  final controller_pass = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    isCheckBoxRemember.value =
        (prefs.getBool("remember") ?? 0) ? prefs.getBool("remember") : false;
    if (isCheckBoxRemember.value == true) {
      await storage.read(key: "email").then((value) {
        if (value != null) controller_email.text = value;
      });
      await storage.read(key: "password").then((value) {
        if (value != null) controller_pass.text = value;
      });
    }
  }

  @override
  Future<void> onReady() {
    super.onReady();
  }

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
  }

  void signInUser() {
    Get.off(() => DashBoardUI(), binding: DashBoardBing());
  }

  void rememberAccount() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember", isCheckBoxRemember.value);
  }

  void signIn() {
    fireBaseAuthentication.signIn(controller_email.text, controller_pass.text,
        () async {
      //On success
      if (isCheckBoxRemember.value == true) {
        await storage.write(key: "email", value: controller_email.text);
        await storage.write(key: "password", value: controller_pass.text);
      }
      fireBaseAuthentication.listenPostCountUser();
      fireBaseAuthentication.userPostCount.stream.listen((event) {
        if (event != null) {
          Get.back();
          signInUser();
        }
      });
    }, (msg) {
      //On fail
      UI_Helper().setDialogMessage(msg, false);
    });
  }

  bool isValid() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (controller_email.text.length < 0 ||
        !regex.hasMatch(controller_email.text)) {
      isEmailValid.value = true;
    } else
      isEmailValid.value = false;

    if (controller_pass.text.length < 5) {
      isPasswordValid.value = true;
    } else
      isPasswordValid.value = false;

    if (isEmailValid == true || isPasswordValid == true) {
      return false;
    } else
      return true;
  }
}
