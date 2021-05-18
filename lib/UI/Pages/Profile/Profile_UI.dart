import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProfileUI extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => ListView.builder(
            //physics: ClampingScrollPhysics(),
            controller: controller.scrollController,
            itemCount: controller.myPro.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == controller.myPro.length) {
                return (controller.totalPost+1) != (controller.myPro.length)
                    ? CupertinoActivityIndicator()
                    : Container();
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
    if (controller.myPro.elementAt(index).Type == "Image") {
      return Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(controller.myPro.elementAt(index).Image),
              fit: BoxFit.contain,
            )),
      );
    } else if (controller.myPro.elementAt(index).Type == "Text") {
      return Text(controller.myPro.elementAt(index).Text,
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFFF101113),
            height: 1.4,
            letterSpacing: 1.4,
          ));
    } else if (controller.myPro.elementAt(index).Type == "Video") {
      return Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  // YoutubePlayer.convertUrlToId(controller.myPro.elementAt(index).Video)
                  image: CachedNetworkImageProvider("https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(controller.myPro.elementAt(index).Video)}/0.jpg" ),
                  fit: BoxFit.contain,
                )),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [BoxShadow(color: Color(0xffCED0D2), spreadRadius: 3)],
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(
              controller.myPro.elementAt(index).VideoTitle,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFF101113),
                height: 1.4,
                letterSpacing: 1.4,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget userList(BuildContext context, ProfileController controller, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.black12,
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(()=> Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image:controller.fireBaseAuthentication.photoUrl.value == null
                          ? AssetImage("assets/signup_banner.png")
                          : controller.fireBaseAuthentication.photoLink.toString().length < 5
                          ? Image.file(File(controller.fireBaseAuthentication.photoUrl.value))
                          .image
                          : CachedNetworkImageProvider(
                          controller.fireBaseAuthentication.photoLink),
                      //controller.myPro.elementAt(index).userPhoto.length > 6
                      //     ? CachedNetworkImageProvider(controller.myPro.elementAt(index).userPhoto)
                      //     : AssetImage('assets/signup_banner.png'),
                      fit: BoxFit.cover,
                    )),
              ),),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(controller.myPro.elementAt(index).Title,
                      style: TextStyle(
                          color: Color(0xFFF101113), fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(width: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(controller.myPro.elementAt(index).Date,
                          style: TextStyle(fontSize: 15, color: Color(0xFFF101113))),
                      SizedBox(width: 3),
                      Icon(Icons.history, color: Color(0xFFF101113), size: 18)
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.more_horiz, color: Color(0xFFF101113), size: 30),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 10),
          getContentSubList(index),
        ],
      ),
    );
  }

  Widget userProfile(BuildContext context) {
    return Column(
      children: [
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
                }, child: null,
              ),
              InkWell(
                onTap: () async {
                  controller.getUploadImage();
                },
                child: Obx(
                  () => CircleAvatar(
                    backgroundImage: controller.fireBaseAuthentication.photoUrl.value == null
                        ? AssetImage("assets/signup_banner.png")
                        : controller.fireBaseAuthentication.photoLink.toString().length < 5
                            ? Image.file(File(controller.fireBaseAuthentication.photoUrl.value))
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
        SizedBox(height: 10)
      ],
    );
  }
}
