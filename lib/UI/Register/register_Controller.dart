import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find<RegisterController>();
  RxBool isHidden = true.obs;

  final myController_email = TextEditingController();
  final myController_pass = TextEditingController();
  final myController_name = TextEditingController();
  final myController_phone = TextEditingController();

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
    print(isHidden);
  }

  bool isValid(String name, String email, String password, String phone){
    if (name == null || name.length ==0){

    }
  }
}
