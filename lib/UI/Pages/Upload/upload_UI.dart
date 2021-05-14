import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Controller.dart';
import 'package:get/get.dart';

class UploadUI extends GetView<UploadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
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
                        image: AssetImage('assets/signup_banner.png'),
                        fit: BoxFit.cover,
                      )),
                ),
                //Text("Post Something"),
                Spacer(),
                Text("X"),
              ],
            ),
            Container(
              width: double.infinity,
              height: 100.0,
              margin: EdgeInsets.all(12),
              child: TextField(
                maxLines: 5,
                obscureText: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "What\'s on your mind?",
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
