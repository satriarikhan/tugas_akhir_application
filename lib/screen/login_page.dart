import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Untuk utf8.encode
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart'; // Import halaman utama

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usersBox = Hive.box('users');
  bool _isRegistering = false;

  // --- State untuk Notifikasi Banner ---
  String? _notificationMessage;
  Color _notificationColor = Colors.red; // Default untuk error
  // --- Akhir State Notifikasi ---

  // Fungsi untuk mengenkripsi password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Ubah password ke bytes
    final digest = sha256.convert(bytes); // Hash menggunakan SHA-256
    return digest.toString(); // Kembalikan sebagai string
  }

  // --- Fungsi Notifikasi Banner BARU ---
  void _showNotification(String message, {bool isSuccess = false}) {
    setState(() {
      _notificationMessage = message;
      _notificationColor = isSuccess ? Colors.green[700]! : Colors.red[700]!;
    });
  }
  // --- Akhir Fungsi Notifikasi ---

  // Fungsi untuk login
  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    if (username.isEmpty || password.isEmpty) {
      _showNotification('Username dan password tidak boleh kosong');
      return;
    }

    // Ambil data user dari database Hive
    final storedPasswordHash = _usersBox.get(username);
    
    if (storedPasswordHash == null) {
      _showNotification('Username tidak ditemukan');
      return;
    }

    // Enkripsi password yang diinput user
    final inputPasswordHash = _hashPassword(password);

    // Bandingkan
    if (inputPasswordHash == storedPasswordHash) {
      // SUKSES LOGIN
      // 1. Simpan session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username); // Simpan username

      // Siapkan pesan sukses untuk dikirim ke MainScreen
      final String successMessage = 'Login berhasil! Selamat datang, $username.';

      // 2. Pindah ke halaman utama dan kirim pesan
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(
            successMessage: successMessage, // Kirim pesan ke MainScreen
          ),
        ),
      );
    } else {
      _showNotification('Password salah');
    }
  }

  // Fungsi untuk registrasi
  void _register() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showNotification('Username dan password tidak boleh kosong');
      return;
    }

    // Cek apakah username sudah ada
    if (_usersBox.containsKey(username)) {
      _showNotification('Username sudah terdaftar');
      return;
    }

    // Enkripsi password
    final hashedPassword = _hashPassword(password);
    
    // Simpan ke database Hive
    _usersBox.put(username, hashedPassword);

    // Tampilkan notifikasi sukses (hijau)
    _showNotification('Registrasi berhasil! Silakan login.', isSuccess: true);
    
    setState(() {
      _isRegistering = false; // Kembali ke mode login
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  /// Widget untuk menampilkan banner notifikasi di atas
  Widget _buildNotificationBanner() {
    if (_notificationMessage == null) {
      // Jangan tampilkan apapun jika tidak ada pesan
      return const SizedBox.shrink(); 
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: _notificationColor,
      child: Row(
        children: [
          Icon(
            _notificationColor == Colors.red[700]! ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _notificationMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                _notificationMessage = null; // Sembunyikan banner
              });
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Registrasi Akun Baru' : 'Login'),
        automaticallyImplyLeading: false, // Hapus tombol kembali
      ),
      body: Column(
        children: [
          // 1. Banner Notifikasi
          _buildNotificationBanner(),

          // 2. Konten Utama (dibuat Expanded agar mengisi sisa ruang)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegistering ? 'Buat Akun' : 'Selamat Datang',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true, // Sembunyikan password
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isRegistering ? _register : _login,
                          child: Text(_isRegistering ? 'Registrasi' : 'Login'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _notificationMessage = null; // Hapus notif saat ganti mode
                            _isRegistering = !_isRegistering; // Ganti mode
                          });
                        },
                        child: Text(
                          _isRegistering 
                            ? 'Sudah punya akun? Login di sini' 
                            : 'Belum punya akun? Registrasi di sini',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}