import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FireBaseAuthentication extends GetxController {
  static FireBaseAuthentication get i => Get.find();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  RxString name = "".obs;
  RxString phone = "".obs;
  RxString email = "".obs;
  RxString photoUrl = "".obs;
  RxInt userPostCount = 0.obs;
  RxInt globalPostCount = 0.obs;
  var photoLink;
  User userCurrent;
  int userSign = 0; // 0 update, 1 delete
  int globalSign = 0; // 0 update, 1 delete

  setData() {
    userCurrent = firebaseAuth.currentUser;
    final dbRef =
        firebaseDatabase.reference().child("users").child(userCurrent.uid);
    dbRef.once().then((DataSnapshot result) async {
      name = (result.value['name']).toString().obs;
      phone = (result.value['phone']).toString().obs;
      email = (userCurrent.email).obs;
      photoUrl = (userCurrent.photoURL).obs;
      if (photoUrl.value?.isNotEmpty == true) {
        await FirebaseStorage.instance
            .ref(photoUrl.value.toString())
            .getDownloadURL()
            .then((value) {
          photoLink = value;
        }).catchError((onError) {
          print("Set data: $onError");
        });
      }
    });
  }

  listenPostCountUser() {
    firebaseDatabase.reference().child(
        "userCountPost/${getEmail(firebaseAuth.currentUser.email)}/count/count/")
      ..onValue.listen((event) {
        if (event.snapshot.value == null)
          userPostCount.value = 0;
        else {
          if (event.snapshot.value >= userPostCount.value) {
            userSign = 0;
          } else
            userSign = 1;
          print("Post Count User: ${event.snapshot.value}");
          print(userSign == 0 ? "update $userSign" : "delete $userSign");
          print(event.snapshot.value);
          print(userPostCount.value);
          userPostCount.value = event.snapshot.value;
        }
      });

    firebaseDatabase.reference().child("globalPostCount/count/")
      ..onValue.listen((event) {
        if (event.snapshot.value == null) globalPostCount.value = 0;
        else {
          if (event.snapshot.value >= globalPostCount.value) {
            globalSign = 0;
          } else
            globalSign = 1;
          print("Post Count Global: ${event.snapshot.value}");
          print(globalSign == 0 ? "update $globalSign" : "delete $globalSign");
          print(event.snapshot.value);
          print(globalPostCount.value);
          globalPostCount.value = event.snapshot.value;
        }
      });
  }

  Future<void> signIn(String email, String password, Function onSuccess,
      Function(String) onSignInError) async {
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      setData();
      onSuccess();
    }).catchError((err) {
      onSignInError(err.code);
    });
  }

  Future<void> signUp(String email, String password, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      userCurrent = user.user;
      _createUser(user.user.uid, name, phone, onSuccess, onRegisterError);
    }).catchError((err) {
      _onSignUpError(err.code, onRegisterError);
    });
  }

  _createUser(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {
      "name": name,
      "phone": phone,
    };
    var ref = firebaseDatabase.reference().child("users");
    ref.child(userId).set(user).then((user) {
      onSuccess();
    }).catchError((err) {
      onRegisterError("SignUp fail, please try again later");
    });
  }

  _onSignUpError(String code, Function(String) onRegisterError) {
    switch (code) {
      case "unknown":
        onRegisterError("Cannot connect to sever. Please try again later");
        break;
      case "email-already-in-use":
        onRegisterError("Email Already IN Use, please use another");
        break;
      case "weak-password":
        onRegisterError("Password is very weak, please Check again");
        break;
    }
  }

  String getEmail(String email) {
    return email.replaceAll('@', '_').replaceAll('.', "_");
  }
}
