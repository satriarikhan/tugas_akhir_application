import 'package:flutter/material.dart';
import 'package:tugas_akhir_application/model/student_model.dart';
import 'package:tugas_akhir_application/service/api_service.dart';
import 'package:tugas_akhir_application/screen/student_detail_screen.dart';

void main() {
  runApp(const MyApp(isLoggedIn: false,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required bool isLoggedIn});

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
      home: const StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> futureStudents;

  // State untuk Search & Filter
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _selectedSchool;
  String? _selectedAttackType;
  String? _selectedRole;

  // Data untuk Dropdown Filter
  final List<String> _schools = [
    'All',
    'Gehenna',
    'Trinity',
    'Millennium',
    'Abydos',
    'Red Winter',
    'Valkyrie',
    'Arius',
    'Hyakkiyako',
    'Shanhaijing',
    'SRT',
  ];
  final List<String> _attackTypes = ['All', 'Explosive', 'Piercing', 'Mystic'];
  final List<String> _roles = [
    'All',
    'DamageDealer',
    'Tank',
    'Healer',
    'Supporter',
    'T.S.',
  ];

  @override
  void initState() {
    super.initState();
    futureStudents = ApiService().getStudents();

    // Listener untuk search bar
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: Column(
        children: [
          // Widget untuk Search Bar
          _buildSearchBar(),

          // Widget untuk Filter Dropdowns
          _buildFilterRow(),

          // Tampilan Grid
          Expanded(
            child: Center(
              child: FutureBuilder<List<Student>>(
                future: futureStudents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final allStudents = snapshot.data!;

                    // Logika filter diterapkan di sini
                    final filteredStudents = allStudents.where((student) {
                      final nameMatch = student.name.toLowerCase().contains(
                        _searchQuery,
                      );
                      final schoolMatch =
                          _selectedSchool == null ||
                          _selectedSchool == 'All' ||
                          student.school == _selectedSchool;
                      final attackMatch =
                          _selectedAttackType == null ||
                          _selectedAttackType == 'All' ||
                          student.bulletType == _selectedAttackType;
                      final roleMatch =
                          _selectedRole == null ||
                          _selectedRole == 'All' ||
                          student.tacticRole == _selectedRole;

                      return nameMatch &&
                          schoolMatch &&
                          attackMatch &&
                          roleMatch;
                    }).toList();

                    // Kirim data yang sudah difilter ke StudentGridView (nama baru)
                    return StudentGridView(students: filteredStudents);
                  } else {
                    return const Text('No data found.');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Cari nama siswa...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  // Widget helper untuk baris Filter
  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        children: [
          _buildDropdownFilter(
            hint: 'Sekolah',
            value: _selectedSchool,
            items: _schools,
            onChanged: (newValue) {
              setState(() {
                _selectedSchool = newValue;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildDropdownFilter(
            hint: 'Serangan',
            value: _selectedAttackType,
            items: _attackTypes,
            onChanged: (newValue) {
              setState(() {
                _selectedAttackType = newValue;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildDropdownFilter(
            hint: 'Role',
            value: _selectedRole,
            items: _roles,
            onChanged: (newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  // Widget helper generik untuk Dropdown
  Widget _buildDropdownFilter({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          dropdownColor: const Color(0xFF2A2A2A),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class StudentGridView extends StatelessWidget {
  final List<Student> students;

  const StudentGridView({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada siswa yang cocok dengan filter.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Gunakan GridView.builder
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),

      // Logika untuk 4 kolom
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 item per baris
        crossAxisSpacing: 10, // Jarak horizontal
        mainAxisSpacing: 10, // Jarak vertikal
        childAspectRatio: 0.8, // Rasio item, sesuaikan jika perlu
      ),

      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        // Panggil widget Grid Item yang baru
        return StudentGridItem(
          student: student,
          onTap: () {
            // Logika navigasi ke detail
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDetailScreen(student: student),
              ),
            );
          },
        );
      },
    );
  }
}

// --- WIDGET BARU UNTUK TAMPILAN ITEM DI GRID ---

class StudentGridItem extends StatelessWidget {
  final Student student;
  final VoidCallback onTap; // Fungsi untuk navigasi

  const StudentGridItem({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Buat kartu bisa diklik
      child: InkWell(
        onTap: onTap, // Panggil fungsi navigasi saat diketuk
        borderRadius: BorderRadius.circular(
          8.0,
        ), // Sesuaikan dengan radius Card
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // Pusatkan konten di dalam kartu
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar Ikon
              CircleAvatar(
                backgroundImage: NetworkImage(student.iconUrl),
                backgroundColor: Colors.transparent,
                radius: 30, // Sedikit lebih besar dari ListTile
              ),
              const SizedBox(height: 12),

              // Nama Siswa
              Text(
                student.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1, // Agar tidak lebih dari 1 baris
                overflow: TextOverflow
                    .ellipsis, // Tampilkan '...' jika teks terlalu panjang
              ),
              const SizedBox(height: 4),

              // Sekolah Siswa
              Text(
                student.school,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
