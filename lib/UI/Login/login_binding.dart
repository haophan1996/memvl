import 'package:get/get.dart';
import 'login_Controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
  }

}