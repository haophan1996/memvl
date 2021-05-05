import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';

class ProfileUI extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Center(
          child:  Text("Profile UI"),
        ),
      ),
    );
  }
}
