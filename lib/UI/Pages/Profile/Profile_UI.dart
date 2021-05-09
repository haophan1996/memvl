import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileUI extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 115,
          width: 115,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Obx(
                () => CircleAvatar(
                  backgroundImage: controller.fireBaseAuthentication.photoUrl.value == null
                      ? AssetImage("assets/signup_banner.png")
                      : controller.fireBaseAuthentication.photoLink.toString().length < 5
                          ? Image.file(File(controller.fireBaseAuthentication.photoUrl.value)).image
                          : CachedNetworkImageProvider(controller.fireBaseAuthentication.photoLink),
                ),
              ),
              Positioned(
                right: -12,
                bottom: 0,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                        side: BorderSide(color: Colors.black)),
                    color: Color(0xFFF5F6F9),
                    onPressed: () async {
                      controller.getUploadImage();
                      print(controller.fireBaseAuthentication.photoLink.toString().length);
                    },
                    child: Image.asset("ic_image_upload.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Obx(
            () => Text(
              controller.fireBaseAuthentication.name.value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
            child: Text(
              "Current Status: To Do",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
            child: Text(
              "Phone: ${controller.fireBaseAuthentication.phone.value} ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 0, 0),
            child: Text(
              "Email: ${controller.fireBaseAuthentication.email} ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
