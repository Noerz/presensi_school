import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:presensi_school/app/core/widgets/custom_icon.dart';

import '../controllers/murid_home_murid_controller.dart';

class MuridHomeMuridView extends GetView<MuridHomeMuridController> {
  const MuridHomeMuridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Untuk ukuran layar responsif

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue, // Warna biru di atas
                    Colors.white, // Warna putih di bawah
                  ],
                ),
              ),
            ),
            Image.asset('assets/images/background1.png'),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan avatar dan teks
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Halo, Boy',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang, di Presensi Online Apps',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Kontainer dengan statistik
                    Container(
                      width: size.width,
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomIconButton(
                            assetIconPath:
                                'assets/icon/masuk.png', // Ganti dengan path ikon Anda
                            size: 40,
                            label: 'Masuk',
                            isLabelAbove: false,
                            onPressed: () {
                              Get.toNamed("/masuk-murid");
                            },
                          ),
                          CustomIconButton(
                            assetIconPath:
                                'assets/icon/keluar.png', // Ganti dengan path ikon Anda
                            size: 40,
                            label: 'Keluar',
                            isLabelAbove: false,
                            onPressed: () {
                              print("Home button pressed");
                            },
                          ),
                          CustomIconButton(
                            assetIconPath:
                                'assets/icon/izin.png', // Ganti dengan path ikon Anda
                            size: 40,
                            label: 'Perizinan',
                            isLabelAbove: false,
                            onPressed: () {
                              print("Home button pressed");
                            },
                          ),
                        ],
                      ),
                      // child: const Text(
                      //   'Informasi Kehadiran Anda Hari Ini!',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                    const SizedBox(height: 20),

                    // Judul untuk presentase kehadiran
                    const Text(
                      "Presentase Kehadiran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Grafik Donat dan keterangan
                    Row(
                      children: [
                        // Donat Chart
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: 65,
                                  title: '65%',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.orange,
                                  value: 20,
                                  title: '20%',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: 15,
                                  title: '15%',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 30,
                              sectionsSpace: 2,
                            ),
                          ),
                        ),

                        // Keterangan Data
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            LegendItem(
                              color: Colors.green,
                              label: "Kehadiran",
                              value: "65%",
                            ),
                            SizedBox(height: 10),
                            LegendItem(
                              color: Colors.orange,
                              label: "Izin/Sakit",
                              value: "20%",
                            ),
                            SizedBox(height: 10),
                            LegendItem(
                              color: Colors.red,
                              label: "Absen",
                              value: "15%",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Kehadiran waktu masuk dan keluar
                    const Text(
                      "Kehadiran Hari Ini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _attendanceCard("07 : 00", "Masuk"),
                        const Text(
                          "=",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        _attendanceCard("14 : 00", "Keluar"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Riwayat Presensi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          // Logika untuk navigasi antar halaman
          if (index == 0) {
            // Home
            print("home");
          } else if (index == 1) {
            // Riwayat Presensi
            print("riwayat");
          } else if (index == 2) {
            // Profile
           Get.toNamed("/profile");
          }
        },
      ),
    );
  }

  // Widget untuk kartu kehadiran
  Widget _attendanceCard(String time, String label) {
    return Container(
      width: 145,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Keterangan Data
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const LegendItem({
    Key? key,
    required this.color,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
