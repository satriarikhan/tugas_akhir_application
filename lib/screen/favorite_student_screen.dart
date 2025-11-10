import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir_application/model/student_model.dart';
import 'package:tugas_akhir_application/service/api_service.dart';
import 'package:tugas_akhir_application/screen/student_screen.dart'; // Untuk memakai ulang StudentGridView

class FavoriteStudentScreen extends StatefulWidget {
  const FavoriteStudentScreen({super.key});

  @override
  State<FavoriteStudentScreen> createState() => _FavoriteStudentScreenState();
}

class _FavoriteStudentScreenState extends State<FavoriteStudentScreen> {
  late Future<List<Student>> _favoriteStudentsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteStudentsFuture = _loadFavorites();
  }

  /// Memuat daftar ID favorit dari SharedPreferences,
  /// mengambil semua data siswa, lalu memfilternya.
  Future<List<Student>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Ambil list ID favorit
    final List<String> favoriteIDs = prefs.getStringList('favorite_students') ?? [];

    if (favoriteIDs.isEmpty) {
      return []; // Kembalikan list kosong jika tidak ada favorit
    }

    // 2. Ambil semua data siswa dari API
    final List<Student> allStudents = await ApiService().getStudents();

    // 3. Filter data siswa
    final List<Student> favoriteStudents = allStudents.where((student) {
      return favoriteIDs.contains(student.id.toString());
    }).toList();

    return favoriteStudents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Students'),
      ),
      body: FutureBuilder<List<Student>>(
        future: _favoriteStudentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return StudentGridView(students: snapshot.data!);
          } else {
            return const Center(
              child: Text(
                'Anda belum memiliki siswa favorit.\n'
                'Tekan ikon hati di halaman detail siswa untuk menambahkannya.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}