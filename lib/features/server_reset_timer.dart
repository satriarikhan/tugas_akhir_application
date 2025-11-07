// lib/widgets/server_reset_timer.dart
// (LOGIKA DIPERBARUI SESUAI PERMINTAAN)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServerResetTimer extends StatefulWidget {
  const ServerResetTimer({super.key});

  @override
  State<ServerResetTimer> createState() => _ServerResetTimerState();
}

class _ServerResetTimerState extends State<ServerResetTimer> {
  Timer? _timer;
  Duration _timeUntilReset = Duration.zero;

  // Jam reset LOKAL yang diinginkan (02:00 Pagi)
  final int _resetHour = 2;

  // Map untuk menyimpan zona waktu dan offset UTC-nya
  final Map<String, int> _timezones = {
    'WIB (GMT+7)': 7,
    'WITA (GMT+8)': 8,
    'WIT (GMT+9)': 9,
    'London (GMT)': 0,
  };

  // Menyimpan zona waktu yang sedang dipilih
  String _selectedTimezoneKey = 'WIB (GMT+7)'; // Default ke WIB

  @override
  void initState() {
    super.initState();
    // Langsung hitung & mulai timer saat widget pertama kali dibuat
    _recalculateTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  /// Fungsi utama yang menghitung countdown berdasarkan zona waktu yang DIPILIH
  void _recalculateTimer() {
    _timer?.cancel(); // Hentikan timer lama jika ada

    // 1. Dapatkan offset UTC dari zona waktu yang dipilih
    final int selectedOffset = _timezones[_selectedTimezoneKey]!;

    // 2. Dapatkan waktu saat ini di zona waktu tersebut
    final nowUtc = DateTime.now().toUtc();
    final nowInSelectedZone = nowUtc.add(Duration(hours: selectedOffset));

    // 3. Tentukan waktu reset (jam 02:00) HARI INI di zona waktu tersebut
    var nextResetTimeInZone = DateTime(
      nowInSelectedZone.year,
      nowInSelectedZone.month,
      nowInSelectedZone.day,
      _resetHour, // Jam 02:00
      0, // Menit
      0, // Detik
    );

    // 4. Jika waktu saat ini SUDAH melewati jam reset hari ini,
    //    maka target resetnya adalah BESOK
    if (nowInSelectedZone.isAfter(nextResetTimeInZone)) {
      nextResetTimeInZone = nextResetTimeInZone.add(const Duration(days: 1));
    }

    // 5. Hitung durasi countdown
    setState(() {
      _timeUntilReset = nextResetTimeInZone.difference(nowInSelectedZone);
    });

    // 6. Mulai timer baru yang menghitung mundur setiap detik
    _startTimer();
  }

  /// Timer yang hanya mengurangi 1 detik dari _timeUntilReset
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeUntilReset.inSeconds <= 0) {
        // Jika countdown habis, hitung ulang untuk hari berikutnya
        _recalculateTimer();
      } else {
        // Kurangi 1 detik
        setState(() {
          _timeUntilReset -= const Duration(seconds: 1);
        });
      }
    });
  }

  // Helper untuk format durasi HH:mm:ss
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // .abs() untuk menghindari tanda minus saat transisi
    final duration = d.abs();
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Ambil nama pendeknya saja (cth: "WIB")
    final String displayName = _selectedTimezoneKey.split(' ')[0];
    // Format jam reset (selalu 02:00)
    final String formattedLocalTime = DateFormat('HH:mm').format(
      DateTime(2000, 1, 1, _resetHour), // Buat tanggal dummy jam 02:00
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Bagian 1: Countdown (Sekarang akan berubah)
          Text(
            'Server Reset in ${_formatDuration(_timeUntilReset)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Bagian 2: Dropdown Pilihan Zona Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Timezone: ", style: TextStyle(color: Colors.grey[400])),
              DropdownButton<String>(
                value: _selectedTimezoneKey,
                dropdownColor: const Color(0xFF2A2A2A),
                underline: Container(height: 1, color: Colors.blue[300]),
                icon: Icon(Icons.arrow_drop_down, color: Colors.blue[300]),
                items: _timezones.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),

                // --- INI BAGIAN PENTING ---
                // Saat diganti, panggil fungsi untuk HITUNG ULANG countdown
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != _selectedTimezoneKey) {
                    setState(() {
                      _selectedTimezoneKey = newValue;
                      _recalculateTimer(); // <--- Hitung ulang di sini
                    });
                  }
                },
              ),
            ],
          ),

          // Bagian 3: Teks Hasil (menampilkan jam 02:00 zona terpilih)
          Text(
            '(Resets at $formattedLocalTime $displayName)',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
