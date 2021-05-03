import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find<RegisterController>();
  FireBaseAuthentication fireBaseAuthentication = new FireBaseAuthentication();
  RxBool isHidden = true.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool isNameValid = false.obs;
  RxBool isPhoneValid = false.obs;
  bool isSignupSuccess = false;
  String message;

  final myController_email = TextEditingController();
  final myController_pass = TextEditingController();
  final myController_name = TextEditingController();
  final myController_phone = TextEditingController();

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
    print(isHidden);
    print(isValid());
  }

  void signup() {
    fireBaseAuthentication.signUp(
        myController_email.text,
        myController_pass.text,
        myController_name.text,
        myController_phone.text, () {
      //If success
      isSignupSuccess = true;
      message = "Thank you for singning up";
    }, (msg) {
      message = msg.toString();
      print(msg.toString());
    });
  }

  bool isValid() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (myController_email.text.length < 0 ||
        !regex.hasMatch(myController_email.text)) {
      isEmailValid.value = true;
    } else
      isEmailValid.value = false;

    if (myController_pass.text.length < 5) {
      isPasswordValid.value = true;
    } else
      isPasswordValid.value = false;

    if (myController_name.text.length == 0) {
      isNameValid.value = true;
    } else
      isNameValid.value = false;
    if (myController_phone.text.length == 0) {
      isPhoneValid.value = true;
    } else
      isPhoneValid.value = false;

    if (isEmailValid == true ||
        isPasswordValid == true ||
        isNameValid == true ||
        isPhoneValid == true) {
      return false;
    } else
      return true;
  }
}
