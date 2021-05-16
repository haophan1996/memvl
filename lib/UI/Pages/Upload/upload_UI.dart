import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mem_vl/Util/UI_Helper.dart';

class UploadUI extends GetView<UploadController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap],
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.processPost();
              },
              child: Text(
                "Post",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
          title: Text('Create Post'),
        ),
        body: Container(
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
                          image: controller.fireBaseAuthentication.photoUrl.value == null
                              ? AssetImage("assets/signup_banner.png")
                              : controller.fireBaseAuthentication.photoLink.toString().length < 5
                                  ? Image.file(
                                          File(controller.fireBaseAuthentication.photoUrl.value))
                                      .image
                                  : CachedNetworkImageProvider(
                                      controller.fireBaseAuthentication.photoLink),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      controller.fireBaseAuthentication.name.value,
                      style:
                          TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Text("Post Something"),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50),
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
                child: Obx(() => (controller.path.value.length < 5 ? youtubePost() : imagePost())),
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    shape: BoxShape.rectangle),
                child: Row(
                  children: <Widget>[
                    Text(
                      " Add to your post",
                      style:
                          TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                    decoration: InputDecoration(
                                      errorText: controller.isValidInputYoutube.value
                                          ? "Invalid Link"
                                          : null,
                                      labelText: "Youtube Link",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (controller.checkInputYoutube() == true) {
                                            controller.path.value = "";
                                            Get.back();
                                          }
                                        },
                                        child: Text("Ok")),
                                    Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          if (controller.isValidInputYoutube.value == true) {
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
            ],
          ),
        ),
      ),
    );
  }

  imagePost() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(image: Image.file(File(controller.path.value)).image),
      ),
    );
  }

  youtubePost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(child: Container(
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),),
        Flexible(
            child: Text(
          " asasccccccccccccccccccccccc",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
  }
}