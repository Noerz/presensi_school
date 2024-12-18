import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_murid_controller.dart';

class LoginController extends GetxController {
  final _authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  RxBool isPasswordVisible = false.obs;
  final activeRole = 'Murid'.obs;

  Future<Map<String, dynamic>> login({
    required String nisn,
    required String password,
  }) async {
    final username =
        activeRole.value == 'Guru' ? usernameController.text : nisn;
    return await _authController.login(username: username, password: password);
  }
}
