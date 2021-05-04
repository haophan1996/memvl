import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/UI/Main/main_Controller.dart';

class MainUI extends GetView<MainController>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: Center(
            child: Obx(() => Text(controller.fireBaseAuthentication.name.toString()),),
          ),
        ),
     );
  }

}