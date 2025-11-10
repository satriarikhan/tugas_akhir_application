// lib/features/server_reset_timer.dart
// (PERBAIKAN BUG "HITUNG MAJU" / COUNTING UP)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerResetTimer extends StatefulWidget {
  const ServerResetTimer({super.key});

  @override
  State<ServerResetTimer> createState() => _ServerResetTimerState();
}

class _ServerResetTimerState extends State<ServerResetTimer> {
  Timer? _timer;
  Duration _timeUntilReset = Duration.zero;

  // Map ini sudah benar (sesuai permintaan Anda di 02:00 WIB, 03:00 WITA, dst.)
  final Map<String, ({int offset, int resetHour})> _timezones = {
    'WIB (GMT+7)': (offset: 7, resetHour: 2), // 02:00 GMT+7 = 19:00 UTC
    'WITA (GMT+8)': (offset: 8, resetHour: 3), // 03:00 GMT+8 = 19:00 UTC
    'WIT (GMT+9)': (offset: 9, resetHour: 4), // 04:00 GMT+9 = 19:00 UTC
    'London (GMT)': (offset: 0, resetHour: 19), // 19:00 GMT+0 = 19:00 UTC
  };

  // State
  String _selectedTimezoneKey = 'WIB (GMT+7)';
  int _selectedOffset = 7;
  int _selectedResetHour = 2;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferencesAndStartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPreferencesAndStartTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedKey =
        prefs.getString('selected_timezone_key') ?? 'WIB (GMT+7)';

    if (_timezones.containsKey(savedKey)) {
      final prefs = _timezones[savedKey]!;
      setState(() {
        _selectedTimezoneKey = savedKey;
        _selectedOffset = prefs.offset;
        _selectedResetHour = prefs.resetHour;
        _isLoading = false;
      });
    } else {
      final defaultPrefs = _timezones['WIB (GMT+7)']!;
      setState(() {
        _selectedTimezoneKey = 'WIB (GMT+7)';
        _selectedOffset = defaultPrefs.offset;
        _selectedResetHour = defaultPrefs.resetHour;
        _isLoading = false;
      });
    }

    _recalculateTimer();
  }

  void _recalculateTimer() {
    _timer?.cancel();

    final nowUtc = DateTime.now().toUtc();
    final nowInSelectedZone = nowUtc.add(Duration(hours: _selectedOffset));

    var nextResetTimeInZone = DateTime(
      nowInSelectedZone.year,
      nowInSelectedZone.month,
      nowInSelectedZone.day,
      _selectedResetHour,
      0, // Menit
      0, // Detik
    );

    if (nowInSelectedZone.isAfter(nextResetTimeInZone)) {
      nextResetTimeInZone = nextResetTimeInZone.add(const Duration(days: 1));
    }

    setState(() {
      _timeUntilReset = nextResetTimeInZone.difference(nowInSelectedZone);
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeUntilReset.inSeconds <= 0) {
        // Jika sudah 0 atau negatif, hitung ulang
        _recalculateTimer();
      } else {
        // Jika masih positif, kurangi 1 detik
        setState(() {
          _timeUntilReset -= const Duration(seconds: 1);
        });
      }
    });
  }

  // --- PERBAIKAN UTAMA ADA DI FUNGSI INI ---
  String _formatDuration(Duration d) {
    // 1. Cek jika durasi negatif (penyebab "hitung maju")
    if (d.isNegative) {
      // Tampilkan 00:00:00, timer akan segera memicu _recalculateTimer()
      return "00:00:00";
    }

    // 2. Hapus .abs()
    final duration = d;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  // --- AKHIR PERBAIKAN ---

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String displayName = _selectedTimezoneKey.split(' ')[0];
    final String formattedLocalTime = DateFormat(
      'HH:mm',
    ).format(DateTime(2000, 1, 1, _selectedResetHour));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Text(
            'Server Reset in ${_formatDuration(_timeUntilReset)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
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
