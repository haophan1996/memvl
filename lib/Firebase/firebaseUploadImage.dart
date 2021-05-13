import 'package:get/get.dart';
import 'firebaseAuth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseUploadImage extends GetxController {
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  File image;
  final picker = ImagePicker();

  Future getImage(Function(String) prepare) async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      image = File(pickerFile.path);
      prepare(image.path);
    } else{
      prepare("");
      print("No file selected");
    }
  }

  uploadImage(String imagePath, Function(String) onSuccess) async {
    print("uploadImage:  $imagePath");
    var firebaseStorage = FirebaseStorage.instance
        .ref()
        .child("ProfileUser/${fireBaseAuthentication.userCurrent.email.replaceAll('@', '_').replaceAll('.', "_")}/${getFileName(imagePath)}");
    var task = firebaseStorage.putFile(File(imagePath));
    await task.then((value) {
      //Success
      onSuccess(value.ref.fullPath);
      print(value);
    }).catchError((err){
      print(err.toString());
    });
  }


  getFileName(String path) {
    return path = image.path.split('/').last;
  }
}
