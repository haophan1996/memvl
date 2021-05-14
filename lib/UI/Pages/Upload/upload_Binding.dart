import 'package:get/get.dart';
import 'package:mem_vl/UI/Pages/Upload/upload_Controller.dart';

class UploadBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<UploadController>(() => UploadController());
  }

}