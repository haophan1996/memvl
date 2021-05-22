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
  List<ProfileModel> myPro = List<ProfileModel>().obs;
  var totalPost = 0;
  var scrollController = ScrollController();
  var imagePath = "".obs;
  var lastVisit;
  var _limit;
  bool stopUpdate = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    totalPost = fireBaseAuthentication.userPostCount.value;
    myPro.add(null);
    totalPost < 5 ? _limit = totalPost : _limit = 5;
    if (totalPost > 0) await loadUserPost(_limit);

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if ((myPro.length - 1) != totalPost) {
          if (stopUpdate == false) {
            totalPost - (myPro.length - 1) < 5
                ? _limit = totalPost
                : _limit = 5;
            await loadMore(_limit);
          }
        }
      }
    });

    fireBaseAuthentication.userPostCount.stream.listen((event) {
      if (fireBaseAuthentication.userSign == 0) listenUserPost();
    });
  }

  onDispose(){
    super.dispose();
  }

  listenUserPost() async {
    totalPost += 1; //Increase total to prevent loadMore
    await _firebaseFirestore
        .collection("memeVl/Posts/collection/")
        .where("UserID",
            isEqualTo: FireBaseAuthentication.i.getEmail(
                FireBaseAuthentication.i.firebaseAuth.currentUser.email))
        .orderBy("Date", descending: true)
        .limit(1)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        myPro.insert(1, myob(element));
      });
    });
  }

  loadMore(int limit) async {
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
      lastVisit = value.docs[value.docs.length - 1];
    });
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
      lastVisit = value.docs[value.docs.length - 1];
    });
  }

  deleteDocument(int index) async {
    stopUpdate = true;
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
      await FirebaseStorage.instance.ref(myPro.elementAt(index).imagePath).delete();
    }


    //Decrease index global
    await FireBaseAuthentication.i.firebaseDatabase
        .reference()
        .child("globalPostCount/")
        .update({
      "count": FireBaseAuthentication.i.globalPostCount.value - 1
    }).catchError((onError) {
      UI_Helper().setDialogMessage(onError, false);
    });

    //Decrease index user
    await FireBaseAuthentication.i.firebaseDatabase
        .reference()
        .child(
            "userCountPost/${FireBaseAuthentication.i.getEmail(FireBaseAuthentication.i.firebaseAuth.currentUser.email)}/count")
        .update({
      "count": FireBaseAuthentication.i.userPostCount.value - 1
    }).then((value) {
      totalPost -= 1;
      stopUpdate = false;
      myPro.removeAt(index);
      UI_Helper().setDialogMessage("Deleted", true);
    }).catchError((onError) {
      UI_Helper().setDialogMessage(onError, false);
    });
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
    myMap[element['PostID']] = myPro.length+1;
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
