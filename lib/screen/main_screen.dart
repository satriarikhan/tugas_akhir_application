// lib/screen/main_screen.dart
// (DIKEMBALIKAN KE VERSI SEBELUM NOTIFIKASI)

import 'package:flutter/material.dart';
import 'package:tugas_akhir_application/features/server_reset_timer.dart';
import 'package:tugas_akhir_application/screen/student_screen.dart';
import 'package:tugas_akhir_application/screen/topup_page.dart'; 

import 'package:tugas_akhir_application/screen/profile_page.dart';

class MainScreen extends StatefulWidget {
  // --- DIHAPUS DARI SINI ---
  // final String? successMessage;
  // --- AKHIR PENGHAPUSAN ---

  const MainScreen({
    super.key,
    // this.successMessage, // <-- DIHAPUS
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), 
    ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- FUNGSI initState DAN _showSuccessSnackBar DIHAPUS DARI SINI ---
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- (Kode HomeScreen dan MenuCard sisanya sama persis, tidak perlu diubah) ---
// --- (Saya sertakan di sini untuk kelengkapan file) ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyArchieve'),
        automaticallyImplyLeading: false, 
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
        'Welcome to MyArchieve! Explore student stats, manage your profile, manage your Favorite Student here, and feel free to top up here as well!.',
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
      child: Column(
        children: [
          MenuCard(
            title: 'Students',
            description: 'View stats, skills, weapons, equipment and more...',
            icon: Icons.people_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentListScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12), 
          MenuCard(
            title: 'Top Up',
            description: 'Beli Pyroxene dan konversi mata uang.',
            icon: Icons.monetization_on_outlined, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TopUpPage()),
              );
            },
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