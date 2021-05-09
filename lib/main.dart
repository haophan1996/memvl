import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'package:mem_vl/UI/Pages/Profile/Profile_Binding.dart';
import 'Firebase/firebaseAuth.dart';
import 'UI/Login/login_UI.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ProfileBinding().dependencies();
  LoginBinding().dependencies();
  Get.put<FireBaseAuthentication>(FireBaseAuthentication());
  Get.put<FireBaseUploadImage>(FireBaseUploadImage());
  if (FirebaseAuth.instance.currentUser != null) FireBaseAuthentication.i.setData();
  runApp(LoginUI());
}
