import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3C7B), // Warna latar ungu
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Logo dan bintang-bintang
          Positioned(
            top: 100,
            child: Column(
              children: [
                
                const SizedBox(height: 20),
                const Text(
                  'Mobile Presensi Apps',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Gambar karakter
          Positioned(
            bottom: 200,
            child: Image.asset(
              'assets/images/char.png',
              height: 300,
            ),
          ),
          // Icon loading
          Positioned(
            bottom: 50,
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Elemen dekorasi (bintang)
          Positioned(
            top: 150,
            left: 50,
            child: Image.asset(
              'assets/images/star.png',
              height: 40,
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: Image.asset(
              'assets/images/star.png',
              height: 40,
            ),
          ),
          Positioned(
            bottom: 350,
            left: 80,
            child: Image.asset(
              'assets/images/star.png',
              height: 30,
            ),
          ),
          Positioned(
            bottom: 300,
            right: 80,
            child: Image.asset(
              'assets/images/star.png',
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
