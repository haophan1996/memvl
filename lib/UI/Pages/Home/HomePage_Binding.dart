import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Home/HomePage_Controller.dart';

class HomePageBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomePageController>(() => HomePageController());
  }

}