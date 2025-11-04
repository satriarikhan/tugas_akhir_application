
class Skill {
  final String skillType; // EX, Basic, Passive, Sub
  final String name;
  final String description;
  final List<String> parameters; // Deskripsi efek per level (["200%", "210%", ...])
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
    // Parsing parameter
    var paramList = json['Parameters'] as List?;
    List<String> skillParams = paramList?.map((p) => p.toString()).toList() ?? [];
    
    return Skill(
      skillType: json['SkillType'],
      name: json['Name'],
      description: json['Desc'],
      parameters: skillParams,
      cost: json['Cost'] ?? 0, // EX cost, lainnya 0 atau null
      
      // URL Ikon Skill (buatan)
      // Formatnya: https://schaledb.s3.ap-northeast-2.amazonaws.com/images/skill/[IconName].webp
      // IconName ada di json['Icon']
      iconUrl: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/skill/${json['Icon']}.webp',
    );
  }
}