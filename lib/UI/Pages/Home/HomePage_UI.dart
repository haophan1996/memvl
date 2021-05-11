import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mem_vl/UI/Pages/Home/HomePage_Controller.dart';
import 'package:get/get.dart';

class HomePageUI extends GetView<HomePageController>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(()=>
            ListView.builder(
              key: const PageStorageKey<String>('SaveScroll'),
              controller: controller.scrollController,
              itemExtent: 80,
              itemCount: controller.myList.length+1,
              itemBuilder: (context, i){
                if (i == controller.myList.length){
                  return CupertinoActivityIndicator();
                }
                return ListTile(
                  title: Text(controller.myList[i]),
                );
              },
            ),
        ),
    );
  }
}
