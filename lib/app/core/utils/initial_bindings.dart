import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/controllers/auth_murid_controller.dart';
import 'package:presensi_school/app/data/repositories/auth/auth_murid_repository.dart';
import 'package:presensi_school/app/data/repositories/profile/profile_repository.dart';
import 'package:presensi_school/app/data/repositories_impl/auth/auth_murid_repository_impl.dart';
import 'package:presensi_school/app/data/repositories_impl/profile/profile_repository_impl.dart';
import 'package:presensi_school/app/modules/profile/controllers/profile_controller.dart';

import 'dio_utils.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put<Dio>(
      DioUtils.initDio(
        dotenv.env['BASE_URL'] ?? const String.fromEnvironment('BASE_URL'),
      ),
      permanent: true,
    );

    Get.put<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ),
    );

    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );

    // Get.put<DompetRepository>(
    //   DompetRepositoryImpl(
    //     client: Get.find<Dio>(),
    //     storage: Get.find<FlutterSecureStorage>(),
    //   ),
    // );
    // Get.put<TransaksiRepository>(
    //   TransaksiRepositoryImpl(
    //     client: Get.find<Dio>(),
    //     storage: Get.find<FlutterSecureStorage>(),
    //   ),
    // );
    Get.put<ProfileRepository>(
      ProfileRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );

    // Inisialisasi controller global (injection wajib diletakkan diakhir)
    Get.put(AuthController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    // Get.put(DompetController(), permanent: true);
    // Get.put(TransaksiController(), permanent: true);
  }
}
