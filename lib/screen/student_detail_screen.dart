// lib/screen/student_detail_screen.dart
import 'package:flutter/material.dart';
// Sesuaikan path import Anda jika diperlukan
import 'package:tugas_akhir_application/model/skill_model.dart';
import 'package:tugas_akhir_application/model/student_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    // Gunakan DefaultTabController sebagai root
    return DefaultTabController(
      length: 4, // Info, Skills, Weapon, Profile
      child: Scaffold(
        appBar: AppBar(
          title: Text(student.name), // Judul AppBar
        ),
        // --- PERBAIKAN UTAMA: Gunakan Column, BUKAN SingleChildScrollView ---
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. GAMBAR PORTRAIT (DI ATAS) ---
            _buildPortraitImage(student),

            // --- 2. INFO DASAR (DI BAWAH GAMBAR) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildBasicInfo(student, context),
            ),

            // --- 3. TAB UI ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TabBar(
                isScrollable: true,
                indicatorWeight: 3.0,
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Skills'),
                  Tab(text: 'Weapon'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.white24),

            // --- 4. KONTEN TAB ---
            // Gunakan Expanded agar TabBarView mengisi sisa ruang
            Expanded(
              child: TabBarView(
                // HAPUS shrinkWrap dan physics dari sini
                children: [
                  // Setiap tab SEKARANG HARUS bisa di-scroll
                  _buildInfoTab(student),
                  _buildSkillsTab(student),
                  _buildWeaponTab(student, context),
                  _buildProfileTab(student),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan gambar portrait
  Widget _buildPortraitImage(Student student) {
    return Image.network(
      student.portraitUrl, // <-- Menggunakan portraitUrl
      width: double.infinity, // Lebar penuh
      height: 300, // Beri tinggi tetap
      fit: BoxFit.cover,
      alignment: Alignment.topCenter, // Fokus di bagian atas gambar

      errorBuilder: (context, error, stackTrace) => Container(
        height: 300,
        color: Colors.grey[800],
        child: const Icon(Icons.error),
      ),
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              height: 300,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
    );
  }

  // Widget untuk info dasar (Nama, Sekolah)
  Widget _buildBasicInfo(Student student, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${student.school} / ${student.club}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }

  // --- KONTEN TAB ---

  /// TAB 1: INFO
  Widget _buildInfoTab(Student student) {
    // --- PERBAIKAN: Tambahkan SingleChildScrollView DI DALAM tab ---
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Atribut'),
          _buildInfoRow('Tipe Skuad', student.squadType),
          _buildInfoRow('Tactic Role', student.tacticRole),
          _buildInfoRow('Tipe Serangan', student.bulletType),
          _buildInfoRow('Tipe Armor', student.armorType),
          _buildInfoRow('Tipe Senjata', student.weaponType),

          _buildSectionTitle('Adaptasi Medan'),

          // --- PERBAIKAN RENDERFLEX: Gunakan Wrap ---
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              _buildTerrainChip('Street', student.terrainStreet),
              _buildTerrainChip('Outdoor', student.terrainOutdoor),
              _buildTerrainChip('Indoor', student.terrainIndoor),
            ],
          ),

          // --- AKHIR PERBAIKAN RENDERFLEX ---
          _buildSectionTitle('Statistik (Level 100)'),
          _buildInfoRow('Max HP', student.maxHp.toString()),
          _buildInfoRow('Max ATK', student.maxAtk.toString()),
          _buildInfoRow('Max DEF', student.maxDef.toString()),
          _buildInfoRow('Max Heal', student.maxHeal.toString()),

          _buildSectionTitle('Equipment'),
          _buildInfoRow(
            'Item 1',
            student.equipment.isNotEmpty ? student.equipment[0] : 'N/A',
          ),
          _buildInfoRow(
            'Item 2',
            student.equipment.length > 1 ? student.equipment[1] : 'N/A',
          ),
          _buildInfoRow(
            'Item 3',
            student.equipment.length > 2 ? student.equipment[2] : 'N/A',
          ),
        ],
      ),
    );
  }

  /// TAB 2: SKILLS
  Widget _buildSkillsTab(Student student) {
    // ListView sudah bisa di-scroll secara default
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: student.skills.length,
      itemBuilder: (context, index) {
        return SkillCard(skill: student.skills[index]);
      },
    );
  }

  /// TAB 3: WEAPON
  Widget _buildWeaponTab(Student student, BuildContext context) {
    // --- PERBAIKAN: Tambahkan SingleChildScrollView DI DALAM tab ---
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student.weapon.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Center(child: Image.network(student.weapon.imagePath, height: 100)),
          const SizedBox(height: 10),
          Text(student.weapon.description),
          _buildSectionTitle('Statistik Senjata (Maks)'),
          _buildInfoRow(
            student.weapon.stat1Type,
            student.weapon.stat1Value.toString(),
          ),
          _buildInfoRow(
            student.weapon.stat2Type,
            student.weapon.stat2Value.toString(),
          ),
        ],
      ),
    );
  }

  /// TAB 4: PROFILE
  Widget _buildProfileTab(Student student) {
    final profile = student.profile;
    // --- PERBAIKAN: Tambahkan SingleChildScrollView DI DALAM tab ---
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            'Nama Lengkap',
            '${profile.familyName} ${profile.personalName}',
          ),
          _buildInfoRow('Ulang Tahun', profile.birthday),
          _buildInfoRow('Usia', profile.age),
          _buildInfoRow('Tinggi', profile.height),
          _buildInfoRow('Hobi', profile.hobbies),
          _buildInfoRow('Ilustrator', profile.illustrator),
          _buildInfoRow('Pengisi Suara (CV)', profile.voiceActor),

          _buildSectionTitle('Perkenalan'),
          Text(
            profile.introduction,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),

          _buildSectionTitle('Deskripsi Profil'),
          Text(profile.profileComment),
        ],
      ),
    );
  }

  // --- WIDGET HELPER KECIL ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.blue[300],
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerrainChip(String terrain, String rank) {
    Color color;
    switch (rank) {
      case 'S':
        color = Colors.red[400]!;
        break;
      case 'A':
        color = Colors.orange[400]!;
        break;
      case 'B':
        color = Colors.yellow[600]!;
        break;
      case 'C':
        color = Colors.green[400]!;
        break;
      default:
        color = Colors.grey[600]!;
    }
    return Chip(
      label: Text(
        '$terrain: $rank',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: color,
    );
  }
}

/// WIDGET KUSTOM UNTUK MENAMPILKAN SKILL
class SkillCard extends StatelessWidget {
  final Skill skill;
  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(skill.iconUrl, width: 60, height: 60),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill.skillType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      if (skill.cost > 0)
                        Text(
                          'Cost: ${skill.cost}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    skill.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(skill.description),
                  const SizedBox(height: 8),
                  if (skill.parameters.isNotEmpty)
                    Text('Level: ${skill.parameters.join(" / ")}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
