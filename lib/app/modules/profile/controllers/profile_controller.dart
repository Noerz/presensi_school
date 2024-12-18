import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/controllers/auth_murid_controller.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:presensi_school/app/data/repositories/profile/profile_repository.dart';

class ProfileController extends GetxController {
  // Dependencies
  final AuthController _authController = Get.find<AuthController>();
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final FlutterSecureStorage _secureStorage = Get.find<FlutterSecureStorage>();

  // State variables
  var isEditMode = false.obs; // Menandakan apakah dalam mode edit
  var isLoading = false.obs;
  var profile = Rx<User?>(null);

  // NISN from secure storage
  var nisn = ''.obs;

  // Controllers for editable fields
  var usernameController = TextEditingController().obs;
  var kelasController = TextEditingController().obs;
  var noHandphoneController = TextEditingController().obs;
  var alamatController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchNISN();
  }

  @override
  void onClose() {
    // Dispose controllers to avoid memory leaks
    usernameController.value.dispose();
    kelasController.value.dispose();
    noHandphoneController.value.dispose();
    alamatController.value.dispose();
    super.onClose();
  }

  /// Fetch NISN from secure storage
  Future<void> fetchNISN() async {
    try {
      final storedNisn = await _secureStorage.read(key: Keys.nisn);
      if (storedNisn != null) {
        nisn.value = storedNisn;
        print('NISN berhasil dimuat: $storedNisn');
      } else {
        Get.snackbar('Error', 'NISN tidak ditemukan di secure storage');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat NISN: $e');
    }
  }

  /// Fetch profile data from the repository
  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final userProfile = await _profileRepository.getProfile();
      if (userProfile != null) {
        profile.value = userProfile;

        // Update nilai pada controllers
        usernameController.value.text = userProfile.nama ?? '';
        kelasController.value.text = userProfile.kelas ?? '';
        noHandphoneController.value.text = userProfile.noHp ?? '';
        alamatController.value.text = userProfile.alamat ?? '';
      } else {
        Get.snackbar("Error", "Data profil kosong!");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat profil: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Toggle edit mode and save changes
  Future<void> toggleEditMode() async {
    if (isEditMode.value) {
      // Jika kita keluar dari mode edit, simpan perubahan
      await saveProfileChanges();
    } else {
      // Masuk ke mode edit
      isEditMode.value = true;
    }
  }

  /// Save the updated profile data
  Future<void> saveProfileChanges() async {
    try {
      // Ambil data yang sudah diubah dari TextEditingController
      final updatedProfile = {
      "username": usernameController.value.text,
      "kelas": kelasController.value.text,
      // "jurusan": jurusanController.value.text,
      "no_handphone": noHandphoneController.value.text,
      "alamat": alamatController.value.text,
    };

    print("Data Updated: $updatedProfile");
      // // Simpan data ke repository atau API
      // final success = await _profileRepository.updateProfile(updatedProfile);
      // if (success) {
      //   Get.snackbar("Success", "Profil berhasil diperbarui");
      // } else {
      //   Get.snackbar("Error", "Gagal memperbarui profil");
      // }
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan perubahan: $e");
    } finally {
      isEditMode.value =
          false; // Keluar dari mode edit setelah menyimpan perubahan
    }
  }

  Future<void> refreshProfile() async {
    try {
      isLoading(true);
      await fetchProfile(); // Memuat ulang data profil
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat ulang profil: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Logout functionality
  Future<Map<String, dynamic>> logout() async {
    return await _authController.logout();
  }
}
