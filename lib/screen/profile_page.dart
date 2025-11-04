// // lib/profile_page.dart
// // (FILE BARU - DENGAN LOGOUT)

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart'; // Import login page
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String _username = '...';
//   File? _profileImage; // File untuk gambar profil

//   @override
//   void initState() {
//     super.initState();
//     _loadUsername();
//   }

//   // Ambil username dari session
//   void _loadUsername() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _username = prefs.getString('username') ?? 'Pengguna';
//     });
//   }
  
//   // Fungsi ambil gambar
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   // Fungsi logout
//   void _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', false); // Hapus session
//     await prefs.remove('username');

//     // Kembali ke halaman login
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Gambar Profil
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
//                 child: _profileImage == null 
//                   ? Icon(Icons.person, size: 50, color: Colors.grey[600])
//                   : null,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(_profileImage == null ? '(Ketuk untuk ganti gambar)' : 'Gambar Profil', style: TextStyle(color: Colors.grey)),
            
//             SizedBox(height: 30),
//             Text(
//               'Selamat Datang,',
//               style: TextStyle(fontSize: 18),
//             ),
//             Text(
//               _username,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: _logout,
//               icon: Icon(Icons.logout),
//               label: Text('Logout'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red[600],
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }