import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetDialog {

   showLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
        child: Container(
          color: Colors.white,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(msg, style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }

   createAlertDialog(BuildContext context, String title, String content,
       bool isSuccess, String message) {
     // set up the button
     Widget okButton = FlatButton(
       child: Text("OK"),
       onPressed: () {
         if (isSuccess) {
           Get.back();
           Get.back();
         } else {
           Get.back();
         }
       },
     );
     // set up the AlertDialog
     AlertDialog alert = AlertDialog(
       title: Text("Meme VL "),
       content: Text(message),
       actions: [
         okButton,
       ],
     );

     // show the dialog
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
   }

}
