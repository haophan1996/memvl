import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:mem_vl/Models/user.dart';


class FireBaseAuthentication extends GetxController {
  static FireBaseAuthentication get i => Get.find();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  RxString name = " ".obs;
  List<UserModel> userInfor = [];

  void getData(){
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;

    final dbRef = FirebaseDatabase.instance.reference().child("users").child(uid);
    dbRef.once().then((result) {
       name = result.value['name'].toString().obs;
       print(name);
    });


    print(uid);
  }

  void signIn(String email, String password, Function onSuccess,
      Function(String) onSignInError) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print("Message: signin success");
      onSuccess();
    }).catchError((err) {
      print("Message: ${err.toString()}");
      onSignInError(err.code);
    });
  }

  void signUp(String email, String password, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {

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
    var ref = FirebaseDatabase.instance.reference().child("users");
    ref.child(userId).set(user).then((user) {
      //This will go to next page
      onSuccess();
    }).catchError((err) {
      onRegisterError("SignUp fail, please try again later");
    });
  }

  _onSignUpError(String code, Function(String) onRegisterError) {
    print("Message: ${code}");
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
}
