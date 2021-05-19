import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashBoard_Controller.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_UI.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Binding.dart';

class DashBoardUI extends GetView<DashBoardController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Meme VL'),),
            body: Obx(() => Center(
              child: controller.widgetOption.elementAt(controller.selectedIndex.value),
            )),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                Get.to(()=> UploadUI(), binding: UploadBinding());
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,

            bottomNavigationBar: Obx(() =>
                BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.assignment_ind_rounded),
                        label: 'Profile'),
                  ],
                  currentIndex: controller.selectedIndex.value,
                  onTap: (index) => controller.selectedIndex.value = index,
                ),
            ),

          );
        }
    );
  }
}
