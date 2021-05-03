import 'package:get/get.dart';
import 'package:mem_vl/UI/Main/main_Controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<MainController>(() => MainController());
  }

}