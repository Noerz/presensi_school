import 'package:get/get.dart';

import '../controllers/murid_masuk_murid_controller.dart';

class MuridMasukMuridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MuridMasukMuridController>(
      () => MuridMasukMuridController(),
    );
  }
}
