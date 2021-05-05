import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashBoard_Controller.dart';

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
            bottomNavigationBar: Obx(() =>
                BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
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
