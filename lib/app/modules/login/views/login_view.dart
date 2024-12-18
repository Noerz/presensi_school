import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan untuk inputFormatters
import 'package:get/get.dart';
import 'package:presensi_school/app/core/widgets/custom_button.dart';
import 'package:presensi_school/app/core/widgets/custom_textfield.dart';
import 'package:presensi_school/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/login.png', width: 292, height: 292),
              Text(
                "Sign In Account",
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xff7E60BF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Obx(() {
                      return CustomTextfield(
                        controller: controller.usernameController,
                        focusNode: FocusNode(),
                        labelText: controller.activeRole.value == 'Guru'
                            ? 'Email'
                            : 'NISN',
                        hintText: controller.activeRole.value == 'Guru'
                            ? 'Masukkan Email'
                            : 'Masukkan NISN',
                        keyboardType: controller.activeRole.value == 'Guru'
                            ? TextInputType.emailAddress
                            : TextInputType.number,
                        inputFormatters: controller.activeRole.value == 'Guru'
                            ? []
                            : [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '*Field tidak boleh kosong';
                          }
                          if (controller.activeRole.value == 'Murid' &&
                              value.length != 10) {
                            return '*NISN harus terdiri dari 10 digit angka';
                          }
                          if (controller.activeRole.value == 'Guru' &&
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                            return '*Email tidak valid';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return CustomTextfield(
                        controller: controller.passwordController,
                        labelText: 'Password',
                        hintText: 'Masukkan Password',
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: GestureDetector(
                          onTap: () => controller.isPasswordVisible.toggle(),
                          child: Icon(controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '*Password harus diisi';
                          }
                          return null;
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _roleButton('Guru'),
                  const SizedBox(width: 50),
                  _roleButton('Murid'),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                width: 380,
                height: 55,
                text: "Login",
                onPressed: () async {
                  if (controller.formKey.currentState?.validate() ?? false) {
                    final result = await controller.login(
                      nisn: controller.usernameController.text,
                      password: controller.passwordController.text,
                    );
                    print("Hasil dari result :$result");
                    if (result['success']) {
                      // Redirect berdasarkan roleCode
                      if (result['roleCode'] == 1) {
                        Get.offAllNamed('/home-murid');
                      } else if (result['roleCode'] == 2) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.snackbar("Login Gagal", "Role tidak dikenali");
                      }
                    } else {
                      Get.snackbar("Login Gagal", result['message']);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleButton(String role) {
    return Obx(() {
      return GestureDetector(
        onTap: () => controller.activeRole.value = role,
        child: Container(
          width: 150,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: controller.activeRole.value == role
                ? Color(0xff433878)
                : Color.fromARGB(255, 249, 237, 252),
          ),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                color: controller.activeRole.value == role
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
