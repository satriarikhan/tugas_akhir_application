// lib/model/student_model.dart
// (Sesuaikan path import Anda jika perlu)
import 'package:tugas_akhir_application/model/profile_model.dart';
import 'package:tugas_akhir_application/model/skill_model.dart';
import 'package:tugas_akhir_application/model/weapon_model.dart';

class Student {
  final int id;
  final String name;
  final String school;
  final String club;
  final String squadType; 
  final String tacticRole; 
  
  final String armorType;
  final String bulletType;
  final String weaponType; 
  final String terrainStreet;
  final String terrainOutdoor;
  final String terrainIndoor;
  
  final List<Skill> skills;
  final Weapon weapon;
  final Profile profile;
  final List<String> equipment; 

  final int maxHp;
  final int maxAtk;
  final int maxDef;
  final int maxHeal;

  final String iconUrl;
  final String portraitUrl;
  final String lobbyUrl; // <-- BARU: Tambahkan baris ini

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
    required this.lobbyUrl, // <-- BARU: Tambahkan baris ini
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String studentId = json['Id'].toString();
    
    var skillList = json['Skills'] as List?;
    List<Skill> studentSkills = skillList?.map((s) => Skill.fromJson(s)).toList() ?? [];

    var equipList = json['Equipment'] as List?;
    List<String> studentEquipment = equipList?.map((e) => e.toString()).toList() ?? [];

    var statsMap = json['Stats'] as Map<String, dynamic>?;
    var maxStatsMap = statsMap?['MaxStats'] as Map<String, dynamic>?;
    var level100StatsMap = maxStatsMap?['100'] as Map<String, dynamic>?;

    int hp = level100StatsMap?['MaxHP'] ?? 0;
    int atk = level100StatsMap?['AttackPower'] ?? 0;
    int def = level100StatsMap?['DefensePower'] ?? 0;
    int heal = level100StatsMap?['HealPower'] ?? 0;
    
    var weaponData = json['Weapon'] as Map<String, dynamic>? ?? {};
    var profileData = json['Profile'] as Map<String, dynamic>? ?? {};

    return Student(
      id: json['Id'],
      name: json['Name'] ?? 'Unknown',
      school: json['School'] ?? 'N/A',
      club: json['Club'] ?? 'N/A',
      squadType: json['SquadType'] ?? 'N/A',
      tacticRole: json['TacticRole'] ?? 'N/A',
      armorType: json['ArmorType'] ?? 'N/A',
      bulletType: json['BulletType'] ?? 'N/A',
      weaponType: json['WeaponType'] ?? 'N/A',
      
      terrainStreet: json['Terrain']?['Street'] ?? 'D',
      terrainOutdoor: json['Terrain']?['Outdoor'] ?? 'D',
      terrainIndoor: json['Terrain']?['Indoor'] ?? 'D',
      
      skills: studentSkills,
      weapon: Weapon.fromJson(weaponData), 
      profile: Profile.fromJson(profileData), 
      equipment: studentEquipment,

      maxHp: hp,
      maxAtk: atk,
      maxDef: def,
      maxHeal: heal,

      iconUrl: 'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/student/icon/$studentId.webp',
      portraitUrl: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/student/portrait/$studentId.webp',
      
      // <-- BARU: Tambahkan URL gambar lobby ---
      lobbyUrl: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/student/lobby/$studentId.webp',
    );
  }
}