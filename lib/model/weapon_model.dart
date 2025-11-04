
class Weapon {
  final String name;
  final String description;
  final String weaponType; // SR, AR, dll. (redundan, tapi ada di JSON)
  final String imagePath; // Path gambar senjata
  
  // Statistik tambahan dari senjata
  final String stat1Type; // cth: "AttackPower"
  final int stat1Value;    // cth: 2000
  final String stat2Type; // cth: "MaxHP"
  final int stat2Value;    // cth: 15000

  Weapon({
    required this.name,
    required this.description,
    required this.weaponType,
    required this.imagePath,
    required this.stat1Type,
    required this.stat1Value,
    required this.stat2Type,
    required this.stat2Value,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
  var stats = json['Stats'];
  
  // Ambil stat, tapi amankan jika 'Type' atau 'Value' tidak ada
  String stat1Type = stats['Type'] != null && stats['Type'].isNotEmpty ? stats['Type'][0] : 'N/A';
  int stat1Value = stats['Value'] != null && stats['Value'].isNotEmpty ? (stats['Value'][0].last ?? 0) : 0;
  
  String stat2Type = stats['Type'] != null && stats['Type'].length > 1 ? stats['Type'][1] : 'N/A';
  int stat2Value = stats['Value'] != null && stats['Value'].length > 1 ? (stats['Value'][1].last ?? 0) : 0;


  return Weapon(
    name: json['Name'] ?? 'No Weapon', // <-- Tambahkan ??
    description: json['Desc'] ?? '',     // <-- Tambahkan ??
    weaponType: json['Type'] ?? 'N/A', // <-- Tambahkan ??
    
    // Amankan path gambar
    imagePath: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/weapon/${json['ImagePath'] ?? 'default'}.webp', // <-- Amankan

    stat1Type: stat1Type,
    stat1Value: stat1Value,
    stat2Type: stat2Type,
    stat2Value: stat2Value,
  );
}
}