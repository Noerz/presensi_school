import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/utils/promt_utils.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF433878), // Warna ungu
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Obx(() => Icon(
                              controller.isEditMode.value
                                  ? Icons.check
                                  : Icons.edit,
                              color: Colors.white,
                            )),
                        onPressed: () async {
                          await controller.toggleEditMode(); // Toggle edit mode
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8), // Radius all 8
                      image: const DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        final nisn = controller.nisn.value.isNotEmpty
                            ? controller.nisn.value
                            : 'NISN tidak tersedia';
                        return Text(
                          "NISN : $nisn",
                          style: const TextStyle(color: Colors.white),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            // Bagian Informasi Profil
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshProfile(); // Memanggil fungsi refresh
                },
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildProfileField(
                          "Username",
                          controller.usernameController.value,
                          controller.isEditMode.value,
                        ),
                        _buildProfileField(
                          "Kelas",
                          controller.kelasController.value,
                          controller.isEditMode.value,
                        ),
                        _buildProfileField(
                          "No. Handphone",
                          controller.noHandphoneController.value,
                          controller.isEditMode.value,
                        ),
                        _buildProfileField(
                          "Alamat",
                          controller.alamatController.value,
                          controller.isEditMode.value,
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Color(0xFF6F2DBD),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: "Riwayat Presensi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.toNamed("/home-murid");
          } else if (index == 1) {
            Get.toNamed("/riwayat-presensi");
          } else if (index == 2) {
            Get.toNamed("/profile");
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 50, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      PromptUtils.showLoading();

                      final result = await controller.logout();

                      PromptUtils.hideLoading();

                      if (result['success']) {
                        Get.offAllNamed('/login');
                      } else {
                        Get.snackbar(
                          'Logout Gagal',
                          result['message'],
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, bool isEditMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isEditMode
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  )
                : Text(
                    controller.text,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
