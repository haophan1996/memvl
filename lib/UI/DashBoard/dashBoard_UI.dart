import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:mem_vl/UI/Login/login_UI.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Controller.dart';
import 'dashBoard_Controller.dart';

// ignore: must_be_immutable
class DashBoardUI extends GetView<DashBoardController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Meme VL'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    FireBaseAuthentication.i.signOut((){
                      Get.offAll(()=> LoginUI(), binding: LoginBinding());
                      FireBaseAuthentication.i.firebaseFirestore.terminate();
                      FireBaseAuthentication.i.firebaseDatabase.reactive.dispose();
                      Get.reset();
                      Get.put<FireBaseAuthentication>(FireBaseAuthentication());
                      Get.put<FireBaseUploadImage>(FireBaseUploadImage());
                    });
                  },
                  child: Text(
                    "Sign out",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
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
