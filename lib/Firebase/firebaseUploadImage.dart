import 'package:get/get.dart';
import 'firebaseAuth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseUploadImage extends GetxController {
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  File image;
  final picker = ImagePicker();
  var pathImage = "".obs;

  Future getImage(Function prepare) async {
    final pickerFile = await picker.getImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      image = File(pickerFile.path);
      pathImage.value = image.path;
      prepare();
    } else{
      print("No file selected");
    }
  }

  uploadImage(Function onSuccess) async {
    print("uploadImage:  ${image}");
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
