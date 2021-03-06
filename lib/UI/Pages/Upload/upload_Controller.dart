import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mem_vl/Util/Youtube.dart';


class UploadController extends GetxController {
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  RxBool isValidInputYoutube = false.obs;
  File image;
  RxString path = "null".obs;
  var type = 0.obs; // 0 text, 1 image, 2 video
  var inputYoutube = TextEditingController();
  var textStatus = TextEditingController();
  var titleYoutube = "".obs;
  var idYoutube = "".obs;
  var currentIdPost = "";
  var timeStamps = "";
  var imagePathFirebase = "";
  var imageLinkFirebase = "";

  @override
  void dispose() {
    path.close();
    type.close();
    idYoutube.close();
    titleYoutube.close();
    isValidInputYoutube.close();
    textStatus.dispose();
    inputYoutube.dispose();
    fireBaseUploadImage.dispose();
    _firebaseFirestore.terminate();
    super.dispose();
  }

  Future<void> processPost() async {
    setID();
    print(currentIdPost);
    print(timeStamps);

    if (type.value == 1) {
      await uploadImage();
      print("imagePathFirebase $imagePathFirebase");
      imageLinkFirebase =
          await fireBaseUploadImage.getImageLink(imagePathFirebase);
    }

    //Add data to global post folder
    await _firebaseFirestore
        .collection("memeVl/Posts/collection")
        .doc(currentIdPost)
        .set({
      "Date": int.parse(timeStamps),
      "Image": imagePathFirebase,
      "ImageLink": imageLinkFirebase,
      "PostID": currentIdPost,
      "Status": textStatus.text,
      "TitleYoutube": titleYoutube.value,
      "Type": type.value,
      "UserID": getEmail(),
      "Video": idYoutube.value
    }).catchError((onError) {
      UI_Helper().setDialogMessage(onError, false);
    }).then((value) {
      Get.back();
      Get.back();
    });

    // //Add post id to owner
    // await _firebaseFirestore
    //     .collection("memeVl/Users/${getEmail()}")
    //     .doc()
    //     .set({
    //   "Date": int.parse(timeStamps),
    //   "PostID": currentIdPost,
    // }).catchError((onError) {
    //   UI_Helper().setDialogMessage(onError, false);
    // });
  }

  getImage() {
    fireBaseUploadImage.image = null;
    fireBaseUploadImage.getImage((value) async {
      if (value != "none") {
        path.value = value;
        type.value = 1;
        inputYoutube.text = "";
      }
      print("selected image Status: $value");
    });
  }

  uploadImage() async {
    await fireBaseUploadImage.uploadImage("UserPostImage", path.value,
        (val) async {
      imagePathFirebase = val;
    });
  }

  checkInputYoutube() async {
    YoutubePlayer.convertUrlToId(inputYoutube.text) == null
        ? isValidInputYoutube.value = true
        : isValidInputYoutube.value = false;

    if (!isValidInputYoutube.value) {
      // valid
      idYoutube.value = YoutubePlayer.convertUrlToId(inputYoutube.text);
      titleYoutube.value = await getTitleYoutube(idYoutube.value);
    }
    return isValidInputYoutube.value == false ? true : false;
  }


  getRemoveMedia() {
    path.value = "";
    inputYoutube.text = "";
    type.value = 0;
  }

  String generateTime() {
    return DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  }

  String getEmail() {
    return FireBaseAuthentication.i
        .getEmail(FireBaseAuthentication.i.firebaseAuth.currentUser.email);
  }

  setID() {
    timeStamps = generateTime();
    currentIdPost =
        FireBaseAuthentication.i.firebaseAuth.currentUser.uid + timeStamps;
  }
}
