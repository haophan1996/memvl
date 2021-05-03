import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class LoginController extends GetxController{
  static LoginController get instance => Get.find<LoginController>();
  RxBool isHidden = true.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;

  final controller_email = TextEditingController();
  final controller_pass = TextEditingController();

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
    print(isHidden);
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

    if (isEmailValid == true || isPasswordValid == true){
      return false;
    } else return true;
  }
}