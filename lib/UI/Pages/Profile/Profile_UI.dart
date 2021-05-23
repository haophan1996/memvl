import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Binding.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_UI.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:mem_vl/Util/Date.dart';

class ProfileUI extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
            controller: controller.scrollController,
            cacheExtent: 999999999999,
            itemCount: controller.myPro.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == controller.myPro.length) {
                return Obx(() => controller.stopLoadMore.value == false
                    ? CupertinoActivityIndicator()
                    : Container());
              }
              if (index == 0) {
                return userProfile(context);
              }
              return userList(context, controller, index);
            }),
      ),
    );
  }

  getContentSubList(int index) {
    if (controller.myPro.elementAt(index).type == 1) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: controller.myPro.elementAt(index).status.length > 0
                ? Text(controller.myPro.elementAt(index).status,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFF101113),
                      height: 1.4,
                      letterSpacing: 1.4,
                    ))
                : Container(),
          ),
          CachedNetworkImage(
            imageUrl: controller.myPro.elementAt(index).imageLink,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        ],
      );
    } else if (controller.myPro.elementAt(index).type == 0) {
      return Text(controller.myPro.elementAt(index).status,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFFF101113),
            height: 1.4,
            letterSpacing: 1.4,
          ));
    } else if (controller.myPro.elementAt(index).type == 2) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: controller.myPro.elementAt(index).status.length > 0
                ? Text(controller.myPro.elementAt(index).status,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFF101113),
                      height: 1.4,
                      letterSpacing: 1.4,
                    ))
                : Container(),
          ),
          Image(
            image: CachedNetworkImageProvider(
              "https://img.youtube.com/vi/${controller.myPro.elementAt(index).video}/0.jpg",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Text(
              controller.myPro.elementAt(index).titleYoutube,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFF101113),
                height: 1.4,
                letterSpacing: 1.4,
              ),
            ),
          )
        ],
      );
    }
  }

  Widget userList(
      BuildContext context, ProfileController controller, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Colors.black12,
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
      padding: EdgeInsets.only(top: 1),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: controller
                                      .fireBaseAuthentication.photoUrl.value ==
                                  null
                              ? AssetImage("assets/signup_banner.png")
                              : controller.fireBaseAuthentication.photoLink
                                          .toString()
                                          .length <
                                      5
                                  ? Image.file(File(controller
                                          .fireBaseAuthentication
                                          .photoUrl
                                          .value))
                                      .image
                                  : CachedNetworkImageProvider(controller
                                      .fireBaseAuthentication.photoLink),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(controller.fireBaseAuthentication.name.value,
                      style: TextStyle(
                          color: Color(0xFFF101113),
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          readTimestamp(controller.myPro.elementAt(index).date),
                          style: TextStyle(
                              fontSize: 15, color: Color(0xFFF101113))),
                      SizedBox(width: 3),
                      Icon(Icons.history, color: Color(0xFFF101113), size: 18)
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon:
                    Icon(Icons.more_horiz, color: Color(0xFFF101113), size: 30),
                onPressed: () {
                  showOptions(context, index);
                },
              ),
            ],
          ),
          getContentSubList(index),
          Row(
            children: <Widget>[
              Spacer(),
              TextButton.icon(
                  onPressed: () async {},
                  icon: Icon(
                    Icons.comment,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Comment",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget userProfile(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    side: BorderSide(color: Colors.red, width: 10)),
                color: Colors.white,
                onPressed: () async {
                  controller.getUploadImage();
                },
                child: null,
              ),
              InkWell(
                onTap: () async {
                  controller.getUploadImage();
                },
                child: Obx(
                  () => CircleAvatar(
                    backgroundImage: controller
                                .fireBaseAuthentication.photoUrl.value ==
                            null
                        ? AssetImage("assets/signup_banner.png")
                        : controller.fireBaseAuthentication.photoLink
                                    .toString()
                                    .length <
                                5
                            ? Image.file(File(controller
                                    .fireBaseAuthentication.photoUrl.value))
                                .image
                            : CachedNetworkImageProvider(
                                controller.fireBaseAuthentication.photoLink),
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
        Padding(
          padding: EdgeInsets.all(5),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
                child: Text("Create post".toUpperCase(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)))),
                onPressed: () {
                  Get.to(() => UploadUI(), binding: UploadBinding());
                }),
          ),
        )
      ],
    );
  }

  void showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 80,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text("Delete"),
                  onTap: () {
                    UI_Helper().setLoading();
                    controller.deleteDocument(index);
                  },
                )
              ],
            ),
          );
        });
  }
}
