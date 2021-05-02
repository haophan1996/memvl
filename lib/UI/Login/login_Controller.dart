import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class LoginController extends GetxController{
  static LoginController get instance => Get.find<LoginController>();
  RxBool isHidden = true.obs;

  final controller_email = TextEditingController();
  final controller_pass = TextEditingController();

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
    print(isHidden);
  }
}