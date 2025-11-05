// lib/model/skill_model.dart (SUDAH DIPERBAIKI)

class Skill {
  final String skillType; // EX, Basic, Passive, Sub
  final String name;
  final String description;
  final List<String>
  parameters; // Deskripsi efek per level (["200%", "210%", ...])
  final int cost; // Biaya EX skill (bisa null)
  final String iconUrl;

  Skill({
    required this.skillType,
    required this.name,
    required this.description,
    required this.parameters,
    required this.cost,
    required this.iconUrl,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    var paramList = json['Parameters'] as List?;
    List<String> skillParams =
        paramList?.map((p) => p.toString()).toList() ?? [];

    int skillCost = 0;
    if (json['Cost'] != null && json['Cost'] is List && (json['Cost'] as List).isNotEmpty) {
      skillCost = (json['Cost'] as List)[0] ?? 0;
    }

    // --- PERBAIKAN UTAMA DI SINI ---
    String skillType = json['SkillType'] ?? 'N/A';
    String skillName = json['Name'] ?? 'No Name';
    String skillDesc = json['Desc'] ?? ''; // Deskripsi dari API
    
    // Jika tipenya 'autoattack', ganti nama dan deskripsi secara manual
    if (skillType == 'autoattack') {
      skillName = 'Normal Attack'; // Perbaikan untuk "No Name"
      skillDesc = 'Deals 100% damage to one enemy.'; // Perbaikan untuk deskripsi
      skillParams = []; // Serangan normal tidak punya level
    }
    // --- AKHIR PERBAIKAN ---

    return Skill(
      skillType: skillType, 
      name: skillName, // Gunakan nama yang sudah diperbaiki
      description: skillDesc, // Gunakan deskripsi yang sudah diperbaiki
      parameters: skillParams, // Gunakan parameter yang sudah diperbaiki
      cost: skillCost, 
      
      iconUrl:
          'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/skill/${json['Icon'] ?? 'default'}.webp',
    );
  }
}