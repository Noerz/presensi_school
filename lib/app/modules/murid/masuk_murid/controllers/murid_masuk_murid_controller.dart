import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_school/app/core/widgets/success_popup.dart';

class MuridMasukMuridController extends GetxController {
  RxString selectedClassroom = "".obs;
  RxString selectedSubject = "".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  RxBool isWithinRadius = false.obs; // Status radius

  void sendLocationToBackend(LatLng location, bool withinRadius) {
    selectedLocation.value = location;
    isWithinRadius.value = withinRadius;
    print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
  }

  void submitAttendance() {
  if (!isWithinRadius.value) {
    Get.snackbar(
      "Lokasi Tidak Sesuai",
      "Anda berada di luar radius sekolah. Silakan menuju lokasi sekolah untuk menggunakan fitur ini.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return; // Batalkan proses jika di luar radius
  }

  final DateTime selectedDateValue = selectedDate.value;
  final LatLng? location = selectedLocation.value;

  if (selectedClassroom.isNotEmpty &&
      selectedSubject.isNotEmpty &&
      location != null) {
    final Map<String, dynamic> attendanceData = {
      "classroom": selectedClassroom.value,
      "subject": selectedSubject.value,
      "date": selectedDateValue.toIso8601String(),
      "location": {
        "latitude": location.latitude,
        "longitude": location.longitude,
      },
    };

    print("Sending data to backend: $attendanceData");

    // Simulasi sukses pengiriman data
    Future.delayed(const Duration(seconds: 1), () {
      SuccessPopup.show(
        message: "Data presensi berhasil dikirim!",
        route: '/home-murid', // Rute halaman tujuan dapat disesuaikan
      );
    });
  } else {
    Get.snackbar(
      "Data Tidak Lengkap",
      "Harap lengkapi semua data sebelum mengirim presensi.",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

}
