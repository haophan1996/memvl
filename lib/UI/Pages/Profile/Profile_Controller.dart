import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mem_vl/Models/user.dart';
import 'package:mem_vl/Util/UI_Helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find<ProfileController>();
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  List myl = List();
  List<ProfileModel> myPro = List<ProfileModel>().obs;
  var totalPost = 0;
  var firstIndex = 0;
  var lastIndex = 0;
  var scrollController = ScrollController();
  var imagePath = "".obs;
  var yt = YoutubeExplode();
  var userEmail;

  @override
  Future<void> onInit() async {
    super.onInit();
    myPro.add(null);
    userEmail = fireBaseAuthentication.userCurrent.email.replaceAll('@', '_').replaceAll('.', "_");

    await loadTotalIndex((value) {
      totalPost = value; // 3
      if (totalPost != 0) {
        if (totalPost >= 5)
          firstIndex = 5;
        else if (totalPost < 5) {
          firstIndex = totalPost;
        }
      }

      _firebaseFirestore
          .collection("memeVl/User/$userEmail/")
          .limit(firstIndex)
          .orderBy("Date", descending: true)
          .get()
          .then((querySnapshot) {
        lastIndex = firstIndex;
        show(querySnapshot);
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // if (lastIndex != firstIndex){
        //   isLoading.value = true;
        //loadMore();
        // }
      }
    });
  }

  Future<void> loadTotalIndex(Function(int) onSuccess) async {
    _firebaseDatabase
        .reference()
        .child("userCountPost/$userEmail")
        .orderByChild("count")
        .once()
        .then((DataSnapshot dataSnapshot) async {
      onSuccess(dataSnapshot.value['count']);
    });
  }

  // loadMore() {
  //   final ref = _firebaseDatabase
  //       .reference()
  //       .child("userPosr")
  //       .child(userEmail)
  //       .orderByChild("Date")
  //       .limitToLast(1);
  //   ref.once().then((DataSnapshot dataSnapshot) async {
  //     values = await dataSnapshot.value;
  //     isLoading.value = false;
  //     show(values);
  //   });
  // }

  show(QuerySnapshot<Map<String, dynamic>> element) async {
    element.docs.forEach((element) {
      myl.add(element['PostID']);
    });

    var image;
    var imageProfile;
    var title;
    for(var element in myl) {
      await _firebaseDatabase
          .reference()
          .child("PostID/$element")
          .once()
          .then((DataSnapshot dataSnap) async {

        if (dataSnap.value['userPhoto'].toString().length > 5){
          await getLinkImage(dataSnap.value['userPhoto'].toString(), (val) {
            imageProfile = val;
          });
        }
        if (dataSnap.value['Type'].toString() == "Image"){
          await getLinkImage(dataSnap.value['Image'].toString(), (val) {
            image = val;
          });
        } else if (dataSnap.value['Type'].toString() == "Video"){
           var get = await yt.videos.get(dataSnap.value['Video'].toString());
            title = get.title;
        }
        myPro.add(ProfileModel(
            dataSnap.value['UserID'].toString(),
            await title,
            dataSnap.value['Video'].toString(),
            dataSnap.value['Text'].toString(),
            dataSnap.value['Title'].toString(),
            dataSnap.value['Type'].toString(),
            await image,
            dataSnap.value['Date'].toString(),
            dataSnap.value['PostID'].toString(),
            await imageProfile));
      });
    }
  }

  getLinkImage(String image, Function(String) onResultLinkImage) async {
    await _firebaseStorage.ref(image).getDownloadURL().then((value) {
      onResultLinkImage(value);
    });
  }

  getUploadImage() async {
    fireBaseUploadImage.getImage((value) {
      if (value.length > 2) {
        UI_Helper().setLoading();
        imagePath.value = value;
        fireBaseUploadImage.uploadImage(imagePath.value, (path) async {
          //onSuccess
          if (fireBaseAuthentication.firebaseAuth.currentUser.photoURL != null) {
            FirebaseStorage.instance
                .ref(fireBaseAuthentication.firebaseAuth.currentUser.photoURL)
                .delete()
                .then((value) {
              print("deleted success");
            });
          }
          fireBaseAuthentication.firebaseAuth.currentUser
              .updateProfile(photoURL: path)
              .then((value) async {
            fireBaseAuthentication.userCurrent.reload();
            fireBaseAuthentication.photoLink = null;
            fireBaseAuthentication.photoUrl.value = imagePath.value.toString();
            UI_Helper().setDialogMessage("Updated", false);
          }).catchError((onError) {
            UI_Helper().setDialogMessage(onError.toString(), false);
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
