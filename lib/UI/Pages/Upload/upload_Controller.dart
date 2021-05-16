import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UploadController extends GetxController {
  static UploadController get instance => Get.find<UploadController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  var type = 0; // 0 text, 1 image, 2 video
  RxBool isValidInputYoutube = false.obs;
  File image;
  RxString path = "".obs;
  var inputYoutube = TextEditingController();
  var textStatus = TextEditingController();

  processPost() {
    print(textStatus);
  }

  getImage() {
    fireBaseUploadImage.image = null;
    fireBaseUploadImage.getImage((value) {
      if (value != "none") {
        path.value = value;
        inputYoutube.text = "";
      }
      print("selected image Status: $value");
    });
  }

  bool checkInputYoutube() {
    YoutubePlayer.convertUrlToId(inputYoutube.text) == null
        ? isValidInputYoutube.value = true
        : isValidInputYoutube.value = false;
    return isValidInputYoutube.value == false ? true : false;
  }
}
