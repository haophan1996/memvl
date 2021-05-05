import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/UI/Pages/Home/HomePage_UI.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_UI.dart';

class DashBoardController extends GetxController{
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
   final selectedIndex = 0.obs;

  List<Widget> widgetOption = <Widget> [
    HomePageUI(),
    ProfileUI(),
  ];

  String txt() {
    fireBaseAuthentication.getData();
    return "ascsd";
  }
}