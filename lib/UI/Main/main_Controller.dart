import 'package:get/get.dart';
import 'package:mem_vl/Firebase/firebaseAuth.dart';

class MainController extends GetxController{
  final FireBaseAuthentication fireBaseAuthentication = Get.find();

  String txt() {
    fireBaseAuthentication.getData();
    return "asc";
  }
}