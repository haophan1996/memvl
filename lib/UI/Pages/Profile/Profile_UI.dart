import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileUI extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Obx(
                () => ListView.builder(
                    physics: ClampingScrollPhysics(),
                    controller: controller.scrollControllerr,
                    itemCount: controller.myList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == controller.myList.length) {
                        return CupertinoActivityIndicator();
                      }
                      if (index == 0) {
                        return userProfile(context);
                      } else
                        return userList(context, index);
                    }),
              ),
            ),
          ],
        ),
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
                    side: BorderSide(color: Colors.red,width: 10)),
                color: Colors.white,
                onPressed: () async {
                  controller.getUploadImage();
                },
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
      ],
    );
  }
}

Widget userList(BuildContext context, int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius:
          BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      color: Colors.black12,
    ),
    width: double.infinity,
    height: 120,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.only(right: 15),
              child: Image(image: AssetImage('assets/signup_banner.png'))),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "details[index]['name']",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.cyanAccent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("details[index]['country']",
                      style: TextStyle(color: Colors.amberAccent, fontSize: 13, letterSpacing: .3)),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.call,
                    color: Colors.cyanAccent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("details[index]['mobile']",
                      style: TextStyle(color: Colors.amber, fontSize: 13, letterSpacing: .3)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
