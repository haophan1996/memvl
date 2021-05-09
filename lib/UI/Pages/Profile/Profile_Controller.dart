import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import '../../../Util/UI_Loading.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find<ProfileController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var imagePath = "".obs;

  getUploadImage() async {
    fireBaseUploadImage.getImage((value) {
      if (value.length > 2) {
        SetDialog().setLoading();
        imagePath.value = value;
        fireBaseUploadImage.uploadImage(imagePath.value, (path) async {
          //onSuccess
          FirebaseStorage.instance.ref(_firebaseAuth.currentUser.photoURL).delete().then((value){
            print("deleted success");
          });
          _firebaseAuth.currentUser
              .updateProfile(photoURL: path)
              .then((value) async {
            fireBaseAuthentication.userCurrent.reload();
            fireBaseAuthentication.photoLink = null;
            fireBaseAuthentication.photoUrl.value = imagePath.value.toString();
            SetDialog().setDialogMessage("Updated",false);
          }).catchError((onError) {
            SetDialog().setDialogMessage(onError.toString(),false);
          });
        });
      }
    });
  }

  getURLImageFirebase(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    var user = await ref.getDownloadURL();
    NetworkImage(user);
  }
}
