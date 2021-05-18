import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UploadController extends GetxController {
  //static UploadController get instance => Get.find<UploadController>();
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
  var yt = YoutubeExplode();
  var currentIdPost = "";
  var timeStamps = "";

  @override
  void dispose() {
    yt.close();
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

    // //Add data to global post folder
    // await _firebaseFirestore
    //     .collection("memeVl/Posts/collection")
    //     .doc(currentIdPost)
    //     .set({
    //   "Date": int.parse(timeStamps),
    //   "Image": path.value,
    //   "ImageLink" : "",
    //   "PostID": currentIdPost,
    //   "Status": textStatus.text,
    //   "TitleYoutube": titleYoutube.value,
    //   "Type": type.value,
    //   "UserID": getEmail(),
    //   "Video": idYoutube.value
    // });
    //
    // //Add post id to owner
    // await _firebaseFirestore.collection("memeVl/Users/${getEmail()}").doc().set({
    //   "Date": int.parse(timeStamps),
    //   "PostID": currentIdPost,
    // });

    // //Increment total index post user
    // FireBaseAuthentication.i.firebaseDatabase
    //     .reference()
    //     .child(
    //     "userCountPost/haophan_gmail_com/count").update({
    //   "count" : FireBaseAuthentication.i.postCount.value+=1
    // });
  }

  getRemoveMedia() {
    path.value = "";
    inputYoutube.text = "";
    type.value = 0;
  }

  getImage() {
    fireBaseUploadImage.image = null;
    fireBaseUploadImage.getImage((value) async {
      if (value != "none") {
        path.value = value;
        type.value = 1;
        inputYoutube.text = "";

        await uploadImage();
      }
      print("selected image Status: $value");
    });
  }

  uploadImage() async{
    await fireBaseUploadImage.uploadImage("UserPostImage/${getEmail()}", path.value, (val) async {
      await fireBaseUploadImage.getImageLink(val).then((value) { print(value);});
    });
  }


  checkInputYoutube() async {
    YoutubePlayer.convertUrlToId(inputYoutube.text) == null
        ? isValidInputYoutube.value = true
        : isValidInputYoutube.value = false;

    if (!isValidInputYoutube.value) {
      // valid
      if (idYoutube.isEmpty) {
        idYoutube.value = YoutubePlayer.convertUrlToId(inputYoutube.text);
        var get = await yt.videos.get(idYoutube.value);
        titleYoutube.value = get.title;
      } else {
        if (idYoutube.value !=
            YoutubePlayer.convertUrlToId(inputYoutube.text)) {
          idYoutube.value = YoutubePlayer.convertUrlToId(inputYoutube.text);
          var get = await yt.videos.get(idYoutube.value);
          titleYoutube.value = get.title;
        }
      }
    }
    return isValidInputYoutube.value == false ? true : false;
  }

  String generateTime() {
    return DateTime
        .now()
        .toUtc()
        .millisecondsSinceEpoch
        .toString();
  }

  String getEmail() {
    return FireBaseAuthentication.i.getEmail();
  }

  setID() {
    timeStamps = generateTime();
    currentIdPost = FireBaseAuthentication.i.userCurrent.uid + timeStamps;
  }
}
