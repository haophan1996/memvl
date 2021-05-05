import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find<ProfileController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();

  getUploadImage(){
    fireBaseUploadImage.getImage((){
      //upload success
      print("prepare");

      Get.defaultDialog(
        content: CircularProgressIndicator(),
        barrierDismissible: false,
        title: "Loading..."
      );


      fireBaseUploadImage.uploadImage((){
        Get.back();
        Get.defaultDialog(
          title: "Status",
          content: Text("Uploaded"),
          textConfirm: "Ok",
          confirmTextColor: Colors.white,
          buttonColor: Colors.green,
          onConfirm: ()=> Get.back(),
        );
      print("success");
      });
    });
  }
}