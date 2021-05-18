import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import '../../Firebase/firebaseUploadImage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find<RegisterController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  RxBool isHidden = true.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool isNameValid = false.obs;
  RxBool isPhoneValid = false.obs;
  bool isSignupSuccess = false;
  String message;
  var imagePath = "".obs;

  final myController_email = TextEditingController();
  final myController_pass = TextEditingController();
  final myController_name = TextEditingController();
  final myController_phone = TextEditingController();

  void togglePassword() {
    isHidden.value = isHidden.value ? false : true;
  }

  void getImagePicker() {
    fireBaseUploadImage.getImage((value) {
      if (value.length > 2) {
        imagePath.value = value;
      }
    });
  }

  void uploadImage() {
    fireBaseUploadImage.uploadImage("ProfileUser",imagePath.value, (path) async {
      //onSuccess
      _firebaseAuth.currentUser
          .updateProfile(photoURL: path)
          .then((value) async {
        fireBaseAuthentication.userCurrent.reload();
        print(fireBaseAuthentication.userCurrent.photoURL);
        UI_Helper().setDialogMessage("Thank you for singning up",true);
        print("signup success");
      }).catchError((onError) {
        UI_Helper().setDialogMessage(onError.toString(),false);
      });
    });
  }

  void signup() {
    UI_Helper().setLoading();
    fireBaseAuthentication.signUp(
        myController_email.text,
        myController_pass.text,
        myController_name.text,
        myController_phone.text, ()  {
      //If success, then update image
      if (imagePath.value.length > 2) {
        uploadImage();
      } else {
        print("here");
        UI_Helper().setDialogMessage("Thank you for singning up",true);
      }
    }, (msg) {
          // If fail, then print error to user
      UI_Helper().setDialogMessage(msg.toString(),false);
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
