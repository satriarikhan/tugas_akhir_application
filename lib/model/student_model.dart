


import 'package:tugas_akhir_application/model/profile_model.dart';
import 'package:tugas_akhir_application/model/skill_model.dart';
import 'package:tugas_akhir_application/model/weapon_model.dart';

class Student {
  final int id;
  final String name;
  final String school;
  final String club;
  final String squadType; // Main / Support
  final String tacticRole; // DamageDealer / Tank / Healer / Supporter / T.S.
  
  // --- Atribut Dasar ---
  final String armorType; // Light / Heavy / Special
  final String bulletType; // Explosive / Piercing / Mystic
  final String weaponType; // SR, AR, HG, SMG, GL, MT, RG, SG, FT
  final String terrainStreet; // Rank: S, A, B, C, D
  final String terrainOutdoor; // Rank
  final String terrainIndoor; // Rank
  
  // --- Relasi Model Lain ---
  final List<Skill> skills;
  final Weapon weapon;
  final Profile profile;
  final List<String> equipment; // Ini bisa jadi List<Item> jika Item punya data sendiri

  // --- Statistik (Contoh Sederhana) ---
  // JSON-nya memiliki BaseStats, MaxStats, dll.
  // Mari kita ambil MaxStats (level 100) sebagai contoh.
  final int maxHp;
  final int maxAtk;
  final int maxDef;
  final int maxHeal;

  // --- URL Gambar (buatan) ---
  final String iconUrl;
  final String portraitUrl;

  Student({
    required this.id,
    required this.name,
    required this.school,
    required this.club,
    required this.squadType,
    required this.tacticRole,
    required this.armorType,
    required this.bulletType,
    required this.weaponType,
    required this.terrainStreet,
    required this.terrainOutdoor,
    required this.terrainIndoor,
    required this.skills,
    required this.weapon,
    required this.profile,
    required this.equipment,
    required this.maxHp,
    required this.maxAtk,
    required this.maxDef,
    required this.maxHeal,
    required this.iconUrl,
    required this.portraitUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String studentId = json['Id'].toString();
    
    // Parsing list skill
    var skillList = json['Skills'] as List;
    List<Skill> studentSkills = skillList.map((s) => Skill.fromJson(s)).toList();

    // Parsing equipment
    var equipList = json['Equipment'] as List;
    List<String> studentEquipment = equipList.map((e) => e.toString()).toList();

    return Student(
      id: json['Id'],
      name: json['Name'],
      school: json['School'] ?? 'N/A',
      club: json['Club'] ?? 'N/A',
      squadType: json['SquadType'],
      tacticRole: json['TacticRole'],
      armorType: json['ArmorType'],
      bulletType: json['BulletType'],
      weaponType: json['WeaponType'],
      terrainStreet: json['Terrain']['Street'],
      terrainOutdoor: json['Terrain']['Outdoor'],
      terrainIndoor: json['Terrain']['Indoor'],
      
      // Menggunakan model yang sudah kita pisah
      skills: studentSkills,
      weapon: Weapon.fromJson(json['Weapon']),
      profile: Profile.fromJson(json['Profile']),
      equipment: studentEquipment,

      // Ambil stats level 100
      maxHp: json['Stats']['MaxStats']['100']['MaxHP'],
      maxAtk: json['Stats']['MaxStats']['100']['AttackPower'],
      maxDef: json['Stats']['MaxStats']['100']['DefensePower'],
      maxHeal: json['Stats']['MaxStats']['100']['HealPower'],

      // URL Gambar
      iconUrl: 'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/student/icon/$studentId.webp',
      portraitUrl: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/student/portrait/$studentId.webp',
    );
  }
}