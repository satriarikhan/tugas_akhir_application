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

    return Skill(
      skillType: json['SkillType'] ?? 'N/A', // <-- Tambahkan ??
      name: json['Name'] ?? 'No Name', // <-- Tambahkan ??
      description: json['Desc'] ?? '', // <-- Tambahkan ??
      parameters: skillParams,
      cost: json['Cost'] ?? 0,

      // Pastikan 'Icon' tidak pernah null sebelum digabungkan
      iconUrl:
          'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/skill/${json['Icon'] ?? 'default'}.webp', // <-- Amankan juga
    );
  }
}
