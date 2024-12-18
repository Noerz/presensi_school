import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:presensi_school/app/data/repositories/auth/auth_murid_repository.dart';

class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final _secureStorage = Get.find<FlutterSecureStorage>();

  User? userAccount;

  // @override
  // void onReady() async {
  //   super.onReady();
  //   await Future.delayed(
  //     const Duration(seconds: 2), // Durasi splashscreen
  //     () async {
  //       // Step 1: Ambil token dari local storage
  //       final token = await _secureStorage.read(key: Keys.token);

  //       // Step 2: Navigasi berdasarkan status login
  //       if (token != null) {
  //         // Ambil data User dari secure storage
  //         final tempUserId = await _secureStorage.read(key: Keys.id) ?? '';
  //         print("User ID dari storage: $tempUserId");

  //         userAccount = User(
  //           idUser: tempUserId,
  //           email: await _secureStorage.read(key: Keys.email) ?? '',
  //           accessToken: token,
  //           roleCode: int.tryParse(
  //               await _secureStorage.read(key: Keys.roleCode) ?? ''),
  //         );
  //         if (userAccount!.roleCode! == 1) {
  //           Get.offAllNamed('/home-murid');
  //         }else{
  //           Get.offAllNamed('/home');
  //         }
  //          // Navigasi ke halaman Home
  //       } else {
  //         Get.offAllNamed('/login'); // Navigasi ke halaman Login
  //       }
  //     },
  //   );
  // }

  /// Simpan token dan data user ke secure storage
  Future<void> _setStorage() async {
    try {
      if (userAccount != null) {
        await _secureStorage.write(key: Keys.id, value: userAccount!.idUser);
        await _secureStorage.write(key: Keys.email, value: userAccount!.email);
        await _secureStorage.write(key: Keys.nisn, value: userAccount!.nisn);
        await _secureStorage.write(
            key: Keys.roleCode, value: userAccount!.roleCode.toString());
        await _secureStorage.write(
            key: Keys.token, value: userAccount!.accessToken);
      }

      final id = await _secureStorage.read(key: Keys.id);
      final nisn = await _secureStorage.read(key: Keys.nisn);
      final email = await _secureStorage.read(key: Keys.email);
      final roleCode = await _secureStorage.read(key: Keys.roleCode);
      final token = await _secureStorage.read(key: Keys.token);
      print("Data berhasil disimpan ke secure storage $id,$nisn,$email,$roleCode,$token");
    } catch (e) {
      print('Error saat menyimpan data ke secure storage: $e');
      rethrow;
    }
  }

  /// Hapus semua data user dari secure storage
  Future<void> _clearStorage() async {
    try {
      await _secureStorage.delete(key: Keys.id);
      await _secureStorage.delete(key: Keys.email);
      await _secureStorage.delete(key: Keys.roleCode);
      await _secureStorage.delete(key: Keys.token);

      print('Data user berhasil dihapus dari storage.');
    } catch (e) {
      print('Error saat menghapus data dari secure storage: $e');
      rethrow;
    }
  }

  /// Fungsi login menggunakan NISN
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      print('Melakukan login dengan data: $username');

      // Step 1: Login ke API
      userAccount = await _authRepository.login(
        username: username,
        password: password,
      );

      print('Login berhasil, data user: ${userAccount!.nisn!}');

      // Step 2: Simpan data user ke secure storage
      await _setStorage();

      return {
        'success': true,
        'message': 'Login berhasil.',
        'roleCode': userAccount?.roleCode,
      };
    } on DioError catch (e) {
      String errorMessage = 'Login gagal. Silakan coba lagi.';
      if (e.response?.data != null) {
        final responseMessage = e.response?.data['message'];
        if (responseMessage == 'Email not found') {
          errorMessage = 'NISN tidak ditemukan.';
        } else if (responseMessage == 'Wrong password') {
          errorMessage = 'Password salah.';
        }
      }
      print('Login gagal: ${e.response?.data}');
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('Login gagal: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  /// Fungsi logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Step 1: Hapus data user dari storage
      await _clearStorage();

      return {
        'success': true,
        'message': 'Logout berhasil.',
      };
    } catch (e) {
      print('Logout gagal: $e');
      return {
        'success': false,
        'message': 'Logout gagal. Silakan coba lagi.',
      };
    }
  }
}
