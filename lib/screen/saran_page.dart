// lib/screen/saran_page.dart
// (DIUBAH MENJADI 2 KOTAK)

import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kesan & Pesan')),
      // Gunakan SingleChildScrollView agar bisa di-scroll jika layar terlalu kecil
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kotak Pertama: Kesan
            _buildMessageBox(
              context: context,
              title: 'Kesan',
              icon: Icons.sentiment_satisfied_alt_outlined,
              iconColor: Colors.cyan[300]!,
              content:
                  'Mata Kuliah Pemrograman Mobile memberikan pengalaman belajar yang sangat berharga. Melalui mata kuliah ini, saya dapat memahami konsep dasar pengembangan aplikasi mobile, mulai dari desain antarmuka hingga implementasi fungsionalitas. Saya juga belajar tentang berbagai framework dan alat yang digunakan dalam pengembangan aplikasi mobile, seperti Flutter dan Dart. Ditambah dengan bimbingan dosen yang sangat ASIK serta metode pembelajaran yang SERU, membuat saya sangat bersemangat dalam setiap tugas sampai DROP beberapa hari saja karena saking semangatnya.',
            ),

            const SizedBox(height: 20), // Jarak antar kotak
            // Kotak Kedua: Pesan
            _buildMessageBox(
              context: context,
              title: 'Pesan',
              icon: Icons.mail_outline,
              iconColor: Colors.amber[300]!,
              content:
                  'Mungkin untuk kedepannya setiap pembelajaran mata kuliahnya bisa dibuat lebih asik lagi agar seluruh mahasiswa dapat lebih bersemangat dalam mengikuti setiap perkuliahan.',
            ),
          ],
        ),
      ),
    );
  }

  /// Widget helper untuk membuat kotak pesan yang seragam
  Widget _buildMessageBox({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Judul dengan Ikon
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),

            // Konten Teks
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[300],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
