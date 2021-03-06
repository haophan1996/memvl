import 'dart:io';
import 'firebaseAuth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
      prepare("none");
      print("No file selected");
    }
  }

  uploadImage(String folder, String imagePath, Function(String) onSuccess) async {
    print("uploadImage:  $imagePath");
    var firebaseStorage = FirebaseStorage.instance
        .ref()
        .child("$folder/${FireBaseAuthentication.i.getEmail(FireBaseAuthentication.i.firebaseAuth.currentUser.email)}/${getFileName(imagePath)}");
    var task = firebaseStorage.putFile(File(imagePath));
    await task.then((value) {
      //Success
      onSuccess(value.ref.fullPath);
      print("Uploaded Image File");
    }).catchError((err){
      print(err.toString());
    });
  }

  Future<String> getImageLink(String path) async{
    return await FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
  }

  getFileName(String path) {
    return path = image.path.split('/').last;
  }
}
