import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBaseAuthentication {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "email-already-in-use":
        onRegisterError("Invalid Email, please Check again");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email Already IN Use, please use another");
        break;
      case "weak-password":
        onRegisterError("Password is very weak, please Check again");
        break;
    }
  }
}
