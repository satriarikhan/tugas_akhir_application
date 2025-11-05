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
    return DefaultTabController(
      length: 4, 
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(student.name),
                floating: true, 
                pinned: false,  
                snap: true,
              ),
              
              SliverToBoxAdapter(
                child: _buildPortraitImage(student),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildBasicInfo(student, context),
                ),
              ),

              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  const TabBar(
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
                pinned: false,
                floating: true,
              ),
              
              SliverToBoxAdapter(
                child: const Divider(height: 1, thickness: 1, color: Colors.white24),
              ),
            ];
          },
          
          body: TabBarView(
            children: [
              _buildInfoTab(student), // Ini akan diperbarui
              _buildSkillsTab(student), 
              _buildWeaponTab(student, context),
              _buildProfileTab(student), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitImage(Student student) {
    return Image.network(
      student.portraitUrl, 
      width: double.infinity, 
      height: 300, 
      fit: BoxFit.cover,
      alignment: Alignment.topCenter, 
      errorBuilder: (context, error, stackTrace) => Container(
        height: 300,
        color: Colors.grey[800],
        child: const Icon(Icons.error, size: 50),
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

  /// TAB 1: INFO (PERBAIKAN UTAMA DI SINI)
  Widget _buildInfoTab(Student student) {
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
          
          // --- PERBAIKAN TATA LETAK STATISTIK ---
          _buildSectionTitle('Statistik (Level 100)'),
          
          _buildStatRow(
            _buildStatItem('Max HP', student.maxHp.toString()),
            _buildStatItem('ATK', student.maxAtk.toString())
          ),
          _buildStatRow(
            _buildStatItem('DEF', student.maxDef.toString()),
            _buildStatItem('Healing', student.maxHeal.toString())
          ),
          _buildStatRow(
            _buildStatItem('Accuracy', student.accuracy.toString()),
            _buildStatItem('Evasion', student.evasion.toString())
          ),
          _buildStatRow(
            _buildStatItem('Crit', student.crit.toString()),
            _buildStatItem('Crit RES', student.critRes.toString())
          ),
          _buildStatRow(
            _buildStatItem('Crit DMG', '${(student.critDmg / 100.0).toStringAsFixed(2)}%'),
            _buildStatItem('Crit DMG RES', '${(student.critDmgRes / 100.0).toStringAsFixed(0)}%')
          ),
          _buildStatRow(
            _buildStatItem('Stability', student.stability.toString()),
            _buildStatItem('Normal Atk Range', student.normalAtkRange.toString())
          ),
          _buildStatRow(
            _buildStatItem('CC Power', student.ccPower.toString()),
            _buildStatItem('CC RES', student.ccRes.toString())
          ),
          _buildStatRow(
            _buildStatItem('Defense Pen', student.defensePen.toString()),
            _buildStatItem('Mag Count', '${student.magCount} (${student.magCost})')
          ),
          // --- AKHIR PERBAIKAN ---

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
    final weapon = student.weapon;
    
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weapon.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Exclusive Weapon / ${weapon.weaponType}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          
          Center(
            child: Image.network(
              weapon.imagePath, 
              height: 100,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100, width: 100, 
                color: Colors.grey[800], 
                child: const Icon(Icons.error, size: 40)
              ),
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      height: 100, width: 100,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(), 
                    ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeaponStatItem(weapon.stat1Type, weapon.stat1Value),
              _buildWeaponStatItem(weapon.stat2Type, weapon.stat2Value),
            ],
          ),
          const SizedBox(height: 24),

          const Divider(height: 1, thickness: 1, color: Colors.white24),
          const SizedBox(height: 16),

          Text(
            weapon.description,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  /// TAB 4: PROFILE
  Widget _buildProfileTab(Student student) {
    final profile = student.profile;
    
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfileGridItem("CV.", profile.voiceActor),
              _buildProfileGridItem("Birthday", profile.birthday),
            ],
          ),
          Row(
            children: [
              _buildProfileGridItem("Age", profile.age),
              _buildProfileGridItem("Height", profile.height),
            ],
          ),
          Row(
            children: [
              _buildProfileGridItem("Design", profile.illustrator),
              _buildProfileGridItem("Illustrator", profile.illustrator),
            ],
          ),
          _buildProfileFullRow("Hobbies", profile.hobbies),
          const Divider(height: 32),
          Text(
            '"${profile.introduction}"',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.profileComment,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Helper baru untuk 1 item stat (kiri ATAU kanan)
  Widget _buildStatItem(String title, String value) {
    // (Anda bisa tambahkan Icon di sini jika mau)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value, 
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  // Helper baru untuk 1 baris (kiri DAN kanan)
  Widget _buildStatRow(Widget statLeft, Widget statRight) {
    return Row(
      children: [
        Expanded(child: statLeft),
        Expanded(child: statRight),
      ],
    );
  }

  Widget _buildWeaponStatItem(String type, int value) {
    if (type == 'N/A') return Expanded(child: Container()); 

    IconData icon;
    Color iconColor;

    switch (type) {
      case 'ATK':
        icon = Icons.flash_on; 
        iconColor = Colors.red[300]!;
        break;
      case 'Max HP':
        icon = Icons.favorite; 
        iconColor = Colors.green[300]!;
        break;
      case 'DEF':
        icon = Icons.shield; 
        iconColor = Colors.blue[300]!;
        break;
      case 'Crit Chance':
        icon = Icons.star; 
        iconColor = Colors.yellow[600]!;
        break;
      default:
        icon = Icons.info_outline;
        iconColor = Colors.grey;
    }

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 4),
              Text(
                type,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '+$value',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileGridItem(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileFullRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, 
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }


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

// --- CLASS HELPER UNTUK SLIVER TAB BAR ---
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}


// --- WIDGET KUSTOM UNTUK SKILL ---
class SkillCard extends StatelessWidget {
  final Skill skill;
  const SkillCard({super.key, required this.skill});

  String _getSkillTypeDisplayName(String rawType) {
    switch (rawType) {
      case 'autoattack':
        return 'Normal Attack'; 
      case 'ex':
        return 'EX Skill'; 
      case 'normal':
        return 'Basic Skill'; 
      case 'gearnormal': 
        return 'Sub Skill'; 
      case 'passive':
        return 'Passive Skill'; 
      default:
        return rawType; 
    }
  }

  String _getUpdatedDescription(String description) {
    return description
        .replaceAll(RegExp(r'<c\d\??>'), '[Parameter]')
        .replaceAll(RegExp(r'<\?\d\??>'), '[Parameter]');
  }


  @override
  Widget build(BuildContext context) {
    String displayName = _getSkillTypeDisplayName(skill.skillType);
    String displayDescription = _getUpdatedDescription(skill.description);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              skill.iconUrl, 
              width: 60, 
              height: 60,
              errorBuilder: (context, error, stackTrace) => 
                Container(width: 60, height: 60, color: Colors.grey[800], child: const Icon(Icons.error))
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          displayName, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          softWrap: true,
                        ),
                      ),
                      if (skill.skillType == 'ex')
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
                  
                  Text(displayDescription, softWrap: true), 
                  
                  const SizedBox(height: 8),
                  
                  if (skill.parameters.isNotEmpty)
                    Text(
                      'Level: ${skill.parameters.join(" / ")}', 
                      softWrap: true 
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}