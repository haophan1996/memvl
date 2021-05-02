import 'package:flutter/material.dart';
import 'package:mem_vl/UI/Login/login_binding.dart';
import 'UI/Login/login_UI.dart';

void main() async {
  LoginBinding().dependencies();
  runApp(LoginUI());
}
