// lib/main.dart
import 'package:flutter/material.dart';
import 'package:tugas_akhir_application/model/student_model.dart';
import 'package:tugas_akhir_application/screen/student_detail_screen.dart';
import 'package:tugas_akhir_application/service/api_service.dart';


void main() {
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
        // Gunakan tema gelap yang lebih mirip SchaleDB
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
        ),
        cardColor: const Color(0xFF1E1E1E),
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

  @override
  void initState() {
    super.initState();
    futureStudents = ApiService().getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SchaleDB - Student List'),
      ),
      body: Center(
        child: FutureBuilder<List<Student>>(
          future: futureStudents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return StudentListView(students: snapshot.data!);
            } else {
              return const Text('No data found.');
            }
          },
        ),
      ),
    );
  }
}

class StudentListView extends StatelessWidget {
  final List<Student> students;

  const StudentListView({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(student.iconUrl),
            backgroundColor: Colors.transparent,
          ),
          title: Text(student.name),
          subtitle: Text('${student.school} - ${student.club}'),
          onTap: () {
            // Logika navigasi ke Halaman Detail
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