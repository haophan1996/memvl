import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String name;
  final String phone;
  final String email;

  UserModel({this.email, this.name, this.phone});

  UserModel.fromSnapShot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        email = snapshot.value["email"],
        phone = snapshot.value["phone"];
}
