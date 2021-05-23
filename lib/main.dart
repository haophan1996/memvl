import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:mem_vl/UI/DashBoard/dashBoard_Binding.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'Firebase/firebaseAuth.dart';
import 'UI/DashBoard/dashBoard_UI.dart';
import 'UI/Login/login_UI.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<FireBaseAuthentication>(FireBaseAuthentication());
  Get.put<FireBaseUploadImage>(FireBaseUploadImage());

  /*
    Reload Firebase
   */
  if (FirebaseAuth.instance.currentUser != null) {
    DashBoardBing().dependencies();
    await FirebaseAuth.instance.currentUser.reload().then((value) {
      FireBaseAuthentication.i.setData();
      FireBaseAuthentication.i.listenPostCountUser();
    });
  } else {
    LoginBinding().dependencies();
  }

  runApp(GetApp());
}

class GetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: (FirebaseAuth.instance.currentUser == null)
            ? LoginUI()
            : DashBoardUI());
  }
}
