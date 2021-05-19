import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UploadUI extends GetView<UploadController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      behavior: HitTestBehavior.deferToChild,
      gestures: [GestureType.onTap],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff3277D8)),
          backgroundColor: Colors.white54,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                UI_Helper().setLoading();
                controller.processPost();
              },
              child: Text(
                "Post",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ],
          title: Text(
            'Create Post',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          color: Colors.white54,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FireBaseAuthentication.i.photoUrl.value == null
                              ? AssetImage("assets/signup_banner.png")
                              : FireBaseAuthentication.i.photoLink
                                          .toString()
                                          .length <
                                      5
                                  ? Image.file(File(FireBaseAuthentication
                                          .i.photoUrl.value))
                                      .image
                                  : CachedNetworkImageProvider(
                                      FireBaseAuthentication.i.photoLink),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      FireBaseAuthentication.i.name.value,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Text("Post Something"),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50, top: 10),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  margin: EdgeInsets.all(12),
                  child: TextField(
                    controller: controller.textStatus,
                    maxLines: 5,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "What\'s on your mind?",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => (controller.type.value == 0
                    ? Container()
                    : controller.type.value == 1
                        ? imagePost()
                        : youtubePost())),
                //Obx(() => (controller.path.value.length < 5 ? youtubePost() : imagePost())),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      shape: BoxShape.rectangle),
                  child: Row(
                    children: <Widget>[
                      Text(
                        " Add to your post",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            controller.getImage();
                          }),
                      IconButton(
                          icon: Icon(Icons.video_collection),
                          onPressed: () async {
                            if (controller.isValidInputYoutube.value == true) {
                              controller.isValidInputYoutube.value = false;
                              controller.inputYoutube.text = "";
                            }
                            Get.defaultDialog(
                              title: "Status",
                              content: Column(
                                children: [
                                  Obx(
                                    () => TextField(
                                      controller: controller.inputYoutube,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                      decoration: InputDecoration(
                                        errorText:
                                            controller.isValidInputYoutube.value
                                                ? "Invalid Link"
                                                : null,
                                        labelText: "Youtube Link",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffCED0D2),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            if (await controller
                                                    .checkInputYoutube() ==
                                                true) {
                                              controller.type.value = 2;
                                              controller.path.value = "";
                                              Get.back();
                                            }
                                          },
                                          child: Text("Ok")),
                                      Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            if (controller.isValidInputYoutube
                                                    .value ==
                                                true) {
                                              controller.inputYoutube.text = "";
                                            }
                                            Get.back();
                                          },
                                          child: Text("Cancel")),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  imagePost() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          // height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: Image.file(File(controller.path.value)).image),
          ),
        ),
        closeMediaButtonContainer(),
        closeMediaButton()
      ],
    );
  }

  youtubePost() {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Obx(
                    () => Image.network(
                      "https://img.youtube.com/vi/${controller.idYoutube.value}/0.jpg",
                    ),
                  ),
                  closeMediaButtonContainer(),
                  closeMediaButton()
                ],
              ),
              Obx(() => Text(
                    "${controller.titleYoutube.value}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        )
      ],
    );
  }

  closeMediaButtonContainer() {
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  closeMediaButton() {
    return Positioned(
      top: -8,
      right: -8,
      child: IconButton(
        enableFeedback: true,
        icon: Icon(Icons.close),
        onPressed: () => controller.getRemoveMedia(),
      ),
    );
  }
}
