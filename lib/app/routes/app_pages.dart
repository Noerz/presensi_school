import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/murid/home_murid/bindings/murid_home_murid_binding.dart';
import '../modules/murid/home_murid/views/murid_home_murid_view.dart';
import '../modules/murid/masuk_murid/bindings/murid_masuk_murid_binding.dart';
import '../modules/murid/masuk_murid/views/murid_masuk_murid_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MURID_HOME_MURID,
      page: () => const MuridHomeMuridView(),
      binding: MuridHomeMuridBinding(),
    ),
    GetPage(
      name: _Paths.MURID_MASUK_MURID,
      page: () => const MuridMasukMuridView(),
      binding: MuridMasukMuridBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
