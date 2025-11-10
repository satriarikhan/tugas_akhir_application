// lib/screen/profile_page.dart
// (FILE DI-AKTIFKAN DARI KOMENTAR ANDA + PENYIMPANAN GAMBAR)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import login page
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '...';
  File? _profileImage; // File untuk gambar profil
  String? _profileImagePath; // Path gambar yang tersimpan

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Ambil username DAN path gambar dari session
  void _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
      _profileImagePath = prefs.getString('profileImagePath');
      if (_profileImagePath != null) {
        _profileImage = File(_profileImagePath!);
      }
    });
  }
  
  // Fungsi ambil gambar DAN SIMPAN path
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Simpan path ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  // Fungsi logout
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Hapus session
    await prefs.remove('username');
    await prefs.remove('profileImagePath'); // Hapus path gambar

    // Kembali ke halaman login
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        automaticallyImplyLeading: false, // Tidak perlu tombol kembali
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Profil
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null 
                    ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                    : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '(Ketuk gambar untuk mengganti)', 
                style: TextStyle(color: Colors.grey[600])
              ),
              
              const SizedBox(height: 30),
              Text(
                'Selamat Datang,',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                _username,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}