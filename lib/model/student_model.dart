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
  final int accuracy;
  final int evasion;
  final int crit;
  final int critRes;
  final int critDmg;
  final int critDmgRes;
  final int stability;
  final int normalAtkRange;
  final int ccPower;
  final int ccRes;
  final int defensePen;
  final int magCount;
  final int magCost;
  final String iconUrl;
  final String portraitUrl;
  final String lobbyUrl;

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
    required this.accuracy,
    required this.evasion,
    required this.crit,
    required this.critRes,
    required this.critDmg,
    required this.critDmgRes,
    required this.stability,
    required this.normalAtkRange,
    required this.ccPower,
    required this.ccRes,
    required this.defensePen,
    required this.magCount,
    required this.magCost,
    required this.iconUrl,
    required this.portraitUrl,
    required this.lobbyUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String studentId = json['Id'].toString(); 

    var skillList = json['Skills'] as List?;
    List<Skill> studentSkills =
        skillList?.map((s) => Skill.fromJson(s)).toList() ?? [];

    var equipList = json['Equipment'] as List?;
    List<String> studentEquipment =
        equipList?.map((e) => e.toString()).toList() ?? [];

    var statsMap = json['Stats'] as Map<String, dynamic>?;
    var maxStatsMap = statsMap?['MaxStats'] as Map<String, dynamic>?;
    var level100StatsMap = maxStatsMap?['100'] as Map<String, dynamic>? ?? {};

    int hp = level100StatsMap['MaxHP'] ?? 0;
    int atk = level100StatsMap['AttackPower'] ?? 0;
    int def = level100StatsMap['DefensePower'] ?? 0;
    int heal = level100StatsMap['HealPower'] ?? 0;
    int accuracy = level100StatsMap['Accuracy'] ?? 0;
    int evasion = level100StatsMap['Evasion'] ?? 0;
    int crit = level100StatsMap['CriticalPoint'] ?? 0;
    int critRes = level100StatsMap['CriticalPointResist'] ?? 0;
    int critDmg = level100StatsMap['CriticalDamage'] ?? 20000; // Default 200%
    int critDmgRes = level100StatsMap['CriticalDamageResist'] ?? 0;
    int stability = level100StatsMap['Stability'] ?? 0;
    int normalAtkRange = level100StatsMap['Range'] ?? 0;
    int ccPower = level100StatsMap['OppressionPower'] ?? 0;
    int ccRes = level100StatsMap['OppressionResist'] ?? 0;
    int defensePen = level100StatsMap['DefensePenetration'] ?? 0;
    int magCount = level100StatsMap['AmmoCount'] ?? 0;
    int magCost = level100StatsMap['AmmoCost'] ?? 0;
    // --- AKHIR PERBAIKAN ---

    var weaponData = json['Weapon'] as Map<String, dynamic>? ?? {};
    var profileData = json; 
    String weaponType = json['WeaponType'] ?? 'N/A';

    return Student(
      id: json['Id'],
      name: json['Name'] ?? 'Unknown',
      school: json['School'] ?? 'N/A',
      club: json['Club'] ?? 'N/A',
      squadType: json['SquadType'] ?? 'N/A',
      tacticRole: json['TacticRole'] ?? 'N/A',
      armorType: json['ArmorType'] ?? 'N/A',
      bulletType: json['BulletType'] ?? 'N/A',
      weaponType: weaponType,
      terrainStreet: json['Terrain']?['Street'] ?? 'D',
      terrainOutdoor: json['Terrain']?['Outdoor'] ?? 'D',
      terrainIndoor: json['Terrain']?['Indoor'] ?? 'D',
      skills: studentSkills,
      weapon: Weapon.fromJson(weaponData, weaponType),
      profile: Profile.fromJson(profileData),
      equipment: studentEquipment,

    
      maxHp: hp,
      maxAtk: atk,
      maxDef: def,
      maxHeal: heal,
      accuracy: accuracy,
      evasion: evasion,
      crit: crit,
      critRes: critRes,
      critDmg: critDmg,
      critDmgRes: critDmgRes,
      stability: stability,
      normalAtkRange: normalAtkRange,
      ccPower: ccPower,
      ccRes: ccRes,
      defensePen: defensePen,
      magCount: magCount,
      magCost: magCost,

      iconUrl:
          'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/student/icon/$studentId.webp',
      portraitUrl:
          'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/student/portrait/$studentId.webp',
      lobbyUrl:
          'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/student/lobby/Lobby_${json['ImagePath']}.webp',
    );
  }
}