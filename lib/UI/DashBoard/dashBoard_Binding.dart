import 'package:get/get.dart';
import 'dashBoard_Controller.dart';

class DashBoardBing extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DashBoardController>(() => DashBoardController());
  }

}