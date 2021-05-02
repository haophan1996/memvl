import 'package:get/get.dart';
import 'package:mem_vl/UI/ForgotPass/forgot_controller.dart';

class ForgotBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ForgotController>(() => ForgotController());
  }

}

