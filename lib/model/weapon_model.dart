
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
    // Stats-nya ada di dalam array 'Stats'
    // Kita ambil stat terakhir (level 50)
    var stats = json['Stats'];
    
    return Weapon(
      name: json['Name'],
      description: json['Desc'],
      weaponType: json['Type'],
      imagePath: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/weapon/${json['ImagePath']}.webp',
      
      // Ambil stat terakhir (level maks)
      stat1Type: stats['Type'][0],
      stat1Value: stats['Value'][0].last, // Ambil nilai terakhir dari array
      stat2Type: stats['Type'][1],
      stat2Value: stats['Value'][1].last, // Ambil nilai terakhir dari array
    );
  }
}