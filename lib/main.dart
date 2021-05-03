import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'UI/Login/login_UI.dart';

Future<void> main() async {
  LoginBinding().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginUI());
}
