import 'package:get/get.dart';
import 'firebaseAuth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseUploadImage extends GetxController {
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  File image;
  final picker = ImagePicker();
  var process = 0.obs;

  Future getImage(Function prepare) async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      prepare();
      image = File(pickerFile.path);
    } else{
      print(image.path);
      print("No file selected");
    }
    update();
  }

  uploadImage(Function onSuccess) async {
    var firebaseStorage = FirebaseStorage.instance
        .ref()
        .child("ProfileUser/${fireBaseAuthentication.user.uid}/${getFileName(image.path)}");
    var task = firebaseStorage.putFile(image);
    await task.then((value) {
      //Success
      onSuccess();
      print(value);
    }).catchError((err){
      print(err.toString());
    });
  }

  getFileName(String path) {
    return path = image.path.split('/').last;
  }
}
