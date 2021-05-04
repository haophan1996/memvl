import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'Firebase/firebaseAuth.dart';
import 'UI/Login/login_UI.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LoginBinding().dependencies();
  Get.put<FireBaseAuthentication>(FireBaseAuthentication());
  runApp(LoginUI());
}
