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

    // --- PERBAIKAN DI SINI ---
    int skillCost = 0;
    // Cek apakah 'Cost' ada, apakah itu List, dan apakah tidak kosong
    if (json['Cost'] != null && json['Cost'] is List && (json['Cost'] as List).isNotEmpty) {
      // Ambil biaya pertama (level 1) dari list
      skillCost = (json['Cost'] as List)[0] ?? 0;
    }
    // --- AKHIR PERBAIKAN ---

    return Skill(
      skillType: json['SkillType'] ?? 'N/A', 
      name: json['Name'] ?? 'No Name', 
      description: json['Desc'] ?? '', 
      parameters: skillParams,
      cost: skillCost, // Gunakan variabel yang sudah diparsing
      
      iconUrl:
          'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/skill/${json['Icon'] ?? 'default'}.webp',
    );
  }
}