import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/UI/DashBoard/dashBoard_Binding.dart';
import 'package:mem_vl/UI/DashBoard/dashBoard_UI.dart';
import 'package:mem_vl/UI/Pages/Home/HomePage_Binding.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Binding.dart';
import 'package:mem_vl/Util/UI_Helper.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find<LoginController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();

  RxBool isHidden = true.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;

  final controller_email = TextEditingController();
  final controller_pass = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    print("check");
  }

  @override
  Future<void> onReady() {
    super.onReady();
    ProfileBinding().dependencies();
    HomePageBinding().dependencies();
    UI_Helper().setLoading();
    if (FirebaseAuth.instance.currentUser != null) {
      fireBaseAuthentication.setData(() {
        fireBaseAuthentication.listenPostCountUser(); // Listen user post
        Get.back();
        signInUser();
      });
    } else
      Get.back();
  }

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
  }

  void signInUser() {
    Get.off(() => DashBoardUI(), binding: DashBoardBing());
  }

  void signIn() {
    fireBaseAuthentication.signIn(controller_email.text, controller_pass.text, () {
      //On success
      Get.back();
      signInUser();
    }, (msg) {
      //On fail
      UI_Helper().setDialogMessage(msg, false);
    });
  }

  bool isValid() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (controller_email.text.length < 0 || !regex.hasMatch(controller_email.text)) {
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
