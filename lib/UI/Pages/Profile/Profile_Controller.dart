import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';
import 'package:mem_vl/Firebase/firebaseUploadImage.dart';
import 'package:mem_vl/Models/user.dart';
import 'package:mem_vl/Util/UI_Helper.dart';

class ProfileController extends GetxController {
  final FireBaseAuthentication fireBaseAuthentication = Get.find();
  final FireBaseUploadImage fireBaseUploadImage = Get.find();
  final Map<String, int> myMap = {};
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<ProfileModel> myPro = List<ProfileModel>().obs;
  var scrollController = ScrollController();
  var imagePath = "".obs;
  var lastVisit;
  final _limit = 5;
  RxBool stopLoadMore = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    myPro.add(null);
    await loadUserPost(_limit);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await loadMore(_limit);
      }
    });

    fireBaseAuthentication.listPostUser.stream.listen((event) {
      listenUserPost(event);
    });
  }

  onDispose() {
    super.dispose();
  }

  listenUserPost(String postID) async {
    if (myMap[fireBaseAuthentication.listPostUser.value] == null) {
      await _firebaseFirestore
          .collection("memeVl/Posts/collection/")
          .doc(postID)
          .get()
          .then((element) {
            if (element['UserID'] == fireBaseAuthentication.getEmail(fireBaseAuthentication.firebaseAuth.currentUser.email)){
              myMap[fireBaseAuthentication.listPostUser.value] = 1;
              myPro.insert(
                  1,
                  ProfileModel(
                      element['Date'],
                      element['Image'],
                      element['ImageLink'],
                      element['PostID'],
                      element['Status'],
                      element['TitleYoutube'],
                      element['Type'],
                      element['UserID'],
                      element['Video']));
            }
      });
    }
  }

  loadMore(int limit) async {
    if (stopLoadMore.value == false) {
      await _firebaseFirestore
          .collection("memeVl/Posts/collection/")
          .where("UserID",
              isEqualTo: FireBaseAuthentication.i.getEmail(
                  FireBaseAuthentication.i.firebaseAuth.currentUser.email))
          .orderBy("Date", descending: true)
          .startAfterDocument(lastVisit)
          .limit(limit)
          .get()
          .then((value) async {
        value.docs.forEach((element) async {
          myPro.add(myob(element));
        });
        if (value.docs.length != 0)
          lastVisit = value.docs[value.docs.length - 1];
        else
          stopLoadMore.value = true;
      }).catchError((err) {
        stopLoadMore.value = true;
      });
    }
  }

  loadUserPost(int limit) async {
    await _firebaseFirestore
        .collection("memeVl/Posts/collection/")
        .where("UserID",
            isEqualTo: FireBaseAuthentication.i.getEmail(
                FireBaseAuthentication.i.firebaseAuth.currentUser.email))
        .orderBy("Date", descending: true)
        .limit(limit)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        myPro.add(myob(element));
      });
      if (value.docs.length - 1 == 0) {
        stopLoadMore.value = true;
      } else
        lastVisit = value.docs[value.docs.length - 1];
    }).catchError((err){
      stopLoadMore.value = true;
    });
  }

  deleteDocument(int index) async {
    //Delete post in Firebase
    await _firebaseFirestore
        .collection("memeVl/Posts/collection/")
        .doc(myPro.elementAt(index).postId)
        .delete()
        .catchError((onError) {
      UI_Helper().setDialogMessage(onError, false);
    });

    //Delete image in Firebase
    if (myPro.elementAt(index).type == 1) {
      await FirebaseStorage.instance
          .ref(myPro.elementAt(index).imagePath)
          .delete();
    }
    myPro.removeAt(index);
    print("her");
    Get.back();
    Get.back();
    if (!stopLoadMore.value) await loadMore(_limit);
  }

  getUploadImage() async {
    fireBaseUploadImage.getImage((value) {
      if (value != "none") {
        UI_Helper().setLoading();
        imagePath.value = value;
        fireBaseUploadImage.uploadImage("ProfileUser", imagePath.value,
            (path) async {
          //onSuccess
          if (fireBaseAuthentication.firebaseAuth.currentUser.photoURL !=
              null) {
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

  Object myob(QueryDocumentSnapshot<Map<String, dynamic>> element) {
    myMap[element['PostID']] = 1;
    return ProfileModel(
        element['Date'],
        element['Image'],
        element['ImageLink'],
        element['PostID'],
        element['Status'],
        element['TitleYoutube'],
        element['Type'],
        element['UserID'],
        element['Video']);
  }
}
