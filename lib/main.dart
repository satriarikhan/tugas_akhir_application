// lib/main.dart
// (PENAMBAHAN INISIALISASI UNTUK FLUTTER WEB)

import 'package:flutter/material.dart';
import 'package:tugas_akhir_application/screen/student_screen.dart';
import 'package:tugas_akhir_application/features/server_reset_timer.dart';

// --- TAMBAHAN 1: Import untuk inisialisasi 'intl' ---
import 'package:intl/date_symbol_data_local.dart';

// --- PERBAIKAN 2: Ubah main menjadi async ---
void main() async {
  // --- PERBAIKAN 3: Pastikan Flutter siap ---
  WidgetsFlutterBinding.ensureInitialized();

  // --- PERBAIKAN 4: Inisialisasi 'intl' sebelum runApp ---
  await initializeDateFormatting(null, null);

  // --- PERBAIKAN 5: Jalankan aplikasi setelah semua siap ---
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blue Archive DB',
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
      home: const HomeScreen(),
    );
  }
}

// ... (Sisa kode HomeScreen, _buildInfoBanner, _buildMenu, dll.
// tidak perlu diubah sama sekali)
// ...
// ... (Saya sembunyikan sisa kodenya karena tidak ada perubahan)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schale DB'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language, size: 18),
            label: const Text('Global'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoBanner(),
            _buildResetTimer(),
            _buildMenu(context),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Archive developed by Nexon Games.\nData is available in multiple languages and supports all game regions. Change language and game region in the Settings menu.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildResetTimer() {
    return const ServerResetTimer();
  }

  Widget _buildMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: MenuCard(
        title: 'Students',
        description: 'View stats, skills, weapons, equipment and more...',
        icon: Icons.people_outline,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentListScreen()),
          );
        },
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.info_outline),
            label: const Text('About'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history),
            label: const Text('Changelog'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.discord),
            label: const Text('Discord'),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    Icon(icon, size: 28, color: Colors.blue[300]),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
