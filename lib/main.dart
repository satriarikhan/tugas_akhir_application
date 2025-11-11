import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tugas_akhir_application/screen/login_page.dart';
import 'package:tugas_akhir_application/screen/main_screen.dart'; 

void main() async {
  // Pastikan semua binding siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi 'intl' untuk timer
  await initializeDateFormatting(null, null);

  // Inisialisasi Hive
  await Hive.initFlutter();
  // Buka box untuk menyimpan data user
  await Hive.openBox('users');

  // Cek status login dari session
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schale DB (Tugas Akhir)',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
        cardColor: const Color(0xFF1E1E1E),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
      // Tentukan halaman awal berdasarkan status login
      home: isLoggedIn ? const MainScreen() : const LoginPage(),
    );
  }
}