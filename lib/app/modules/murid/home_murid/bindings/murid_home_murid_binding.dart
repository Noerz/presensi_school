import 'package:get/get.dart';

import '../controllers/murid_home_murid_controller.dart';

class MuridHomeMuridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MuridHomeMuridController>(
      () => MuridHomeMuridController(),
    );
  }
}
