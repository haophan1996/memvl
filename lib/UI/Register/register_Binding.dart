import 'package:get/get.dart';
import 'package:mem_vl/UI/Register/register_Controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<RegisterController>(() => RegisterController());
  }

}