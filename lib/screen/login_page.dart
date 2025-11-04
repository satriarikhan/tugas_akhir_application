// // lib/login_page.dart
// // (FILE BARU)

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert'; // Untuk utf8.encode
// import 'package:shared_preferences/shared_preferences.dart';
// import 'main_screen.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _usersBox = Hive.box('users');
//   bool _isRegistering = false;

//   // Fungsi untuk mengenkripsi password
//   String _hashPassword(String password) {
//     final bytes = utf8.encode(password); // Ubah password ke bytes
//     final digest = sha256.convert(bytes); // Hash menggunakan SHA-256
//     return digest.toString(); // Kembalikan sebagai string
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   // Fungsi untuk login
//   void _login() async {
//     final username = _usernameController.text;
//     final password = _passwordController.text;
    
//     if (username.isEmpty || password.isEmpty) {
//       _showSnackbar('Username dan password tidak boleh kosong');
//       return;
//     }

//     // Ambil data user dari database Hive
//     final storedPasswordHash = _usersBox.get(username);
    
//     if (storedPasswordHash == null) {
//       _showSnackbar('Username tidak ditemukan');
//       return;
//     }

//     // Enkripsi password yang diinput user
//     final inputPasswordHash = _hashPassword(password);

//     // Bandingkan
//     if (inputPasswordHash == storedPasswordHash) {
//       // SUKSES LOGIN
//       // 1. Simpan session
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//       await prefs.setString('username', username); // Simpan username

//       // 2. Pindah ke halaman utama
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     } else {
//       _showSnackbar('Password salah');
//     }
//   }

//   // Fungsi untuk registrasi
//   void _register() {
//     final username = _usernameController.text;
//     final password = _passwordController.text;

//     if (username.isEmpty || password.isEmpty) {
//       _showSnackbar('Username dan password tidak boleh kosong');
//       return;
//     }

//     // Cek apakah username sudah ada
//     if (_usersBox.containsKey(username)) {
//       _showSnackbar('Username sudah terdaftar');
//       return;
//     }

//     // Enkripsi password
//     final hashedPassword = _hashPassword(password);
    
//     // Simpan ke database Hive
//     _usersBox.put(username, hashedPassword);

//     _showSnackbar('Registrasi berhasil! Silakan login.');
//     setState(() {
//       _isRegistering = false; // Kembali ke mode login
//       _usernameController.clear();
//       _passwordController.clear();
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isRegistering ? 'Registrasi Akun Baru' : 'Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   _isRegistering ? 'Buat Akun' : 'Selamat Datang',
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 SizedBox(height: 30),
//                 TextField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true, // Sembunyikan password
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isRegistering ? _register : _login,
//                     child: Text(_isRegistering ? 'Registrasi' : 'Login'),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _isRegistering = !_isRegistering; // Ganti mode
//                     });
//                   },
//                   child: Text(
//                     _isRegistering 
//                       ? 'Sudah punya akun? Login di sini' 
//                       : 'Belum punya akun? Registrasi di sini',
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }