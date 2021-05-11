import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePageController extends GetxController {
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  var user = FirebaseAuth.instance.currentUser;

  List myList;
  ScrollController scrollController = ScrollController();
  var _currentMax = 10;


  @override
  void onInit() {
    super.onInit();
    myList = List
        .generate(10, (i) => "Item: ${i + 1}")
        .obs;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  loadMore() {

    // var ref = _firebaseDatabase.reference().child("UserHistoryPost/UserID").orderByChild("Date");
    // ref.once().then((DataSnapshot dataSnapshot){
    //   Map<dynamic, dynamic> values=dataSnapshot.value;
    //   values.forEach((key, value) {
    //     print(value['Date']);
    //   });
    // });

    // var ref = _firebaseDatabase.reference().child("UserPost").orderByChild("Date");
    // ref.once().then((DataSnapshot dataSnapshot){
    //   Map<dynamic, dynamic> values=dataSnapshot.value;
    //   values.forEach((key, value) {
    //     print(value['Type']);
    //   });
    // });


    for(var i = _currentMax; i < _currentMax+10;i++){
      myList.add("Item: ${i+1}");
    }
    _currentMax = _currentMax +10;

  }
}