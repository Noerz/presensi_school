  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:latlong2/latlong.dart';
  import 'package:presensi_school/app/core/widgets/maps/gps_map_widget.dart';
  import 'package:presensi_school/app/core/widgets/student_info_card.dart';
  import 'package:presensi_school/app/core/widgets/custom_app_bar.dart';
  import 'package:presensi_school/app/core/widgets/date_selector.dart';
  import 'package:presensi_school/app/core/widgets/dropdown_field.dart';
  import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu

  import '../controllers/murid_masuk_murid_controller.dart';

  class MuridMasukMuridView extends GetView<MuridMasukMuridController> {
    const MuridMasukMuridView({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Absen Masuk",
            onBackPressed: () => Get.back(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Widget untuk memilih tanggal
                DateSelector(
                  onDateSelected: (selectedDate) {
                    controller.selectedDate.value = selectedDate;
                  },
                ),
                const SizedBox(height: 10),
                // Menampilkan tanggal dan waktu yang dipilih
                Obx(() {
                  final selectedDate = controller.selectedDate.value;
                  final selectedTime = controller.selectedDate.value;
                  final formattedDate = _formatDate(selectedDate);
                  final formattedTime = _formatTime(selectedTime);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$formattedDate",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      
                    ],
                  );
                }),
                const SizedBox(height: 20),
                // Informasi siswa
                StudentInfoCard(
                  nisn: "1234567890",
                  name: "Test",
                  grade: "IX, Pemasaran",
                ),
                const SizedBox(height: 20),
                // Dropdown untuk memilih ruang kelas
                DropdownField(
                  hintText: "Pilih Ruang Kelas",
                  items: const [
                    DropdownMenuItem(value: "Ruang A", child: Text("Ruang A")),
                    DropdownMenuItem(value: "Ruang B", child: Text("Ruang B")),
                  ],
                  onChanged: (value) => controller.selectedClassroom.value = value ?? "",
                ),
                const SizedBox(height: 20),
                // Dropdown untuk memilih mata pelajaran
                DropdownField(
                  hintText: "Mata Pelajaran",
                  items: const [
                    DropdownMenuItem(value: "Matematika", child: Text("Matematika")),
                    DropdownMenuItem(value: "Bahasa Inggris", child: Text("Bahasa Inggris")),
                  ],
                  onChanged: (value) => controller.selectedSubject.value = value ?? "",
                ),
                const SizedBox(height: 20),
                // Header dan widget peta untuk geolocation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Geolocation Maps",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<DateTime>(
                      stream: Stream.periodic(const Duration(seconds: 1),
                          (_) => DateTime.now()), // Stream waktu
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final time = snapshot.data!;
                          return Text(
                            _formatTime(time),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          return const Text("Loading...");
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  child: MapWidget(
                    onLocationFetched: controller.sendLocationToBackend,
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E348E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Submit Presensi",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Fungsi untuk format tanggal seperti "Selasa, 10/05/2024"
    String _formatDate(DateTime date) {
      final weekdays = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      final weekdayName = weekdays[date.weekday - 1];
      final formattedDate = DateFormat('dd/MM/yyyy').format(date);
      return '$weekdayName, $formattedDate';
    }

    // Fungsi untuk format waktu seperti "13:45"
    String _formatTime(DateTime date) {
      return DateFormat('HH:mm:ss').format(date);
    }
  }
