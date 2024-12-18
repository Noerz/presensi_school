import 'package:get/get.dart';
import 'package:presensi_school/app/controllers/auth_murid_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final _authController = Get.find<AuthController>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<Map<String, dynamic>> logout() async {
    return await _authController.logout();
  }
}
