import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mem_vl/UI/Pages/Home/HomePage_Controller.dart';
import 'package:get/get.dart';

class HomePageUI extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
         constraints: BoxConstraints.expand(),
         color: Colors.white,
         child: Center(
           child:  Text("Homepage UI"),
         ),
       ),
    );
  }
}