import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';

class DashBoardController extends GetxController{
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
   final selectedIndex = 0.obs;

  List<Widget> widgetOption = <Widget> [
    Text('Home'),
    Text('Profile'),
  ].obs;

  String txt() {
    fireBaseAuthentication.getData();
    return "ascsd";
  }
}