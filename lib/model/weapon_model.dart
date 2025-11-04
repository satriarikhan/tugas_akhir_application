
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
    
    // --- PERBAIKAN UNTUK KEAMANAN DATA ---
    String stat1Type = 'N/A';
    int stat1Value = 0;
    // Cek apakah 'Type' ada dan tidak kosong
    if (stats['Type'] != null && (stats['Type'] as List).isNotEmpty) {
      stat1Type = stats['Type'][0];
    }
    // Cek apakah 'Value' ada, tidak kosong, dan list di dalamnya tidak kosong
    if (stats['Value'] != null && (stats['Value'] as List).isNotEmpty) {
      var valueList1 = stats['Value'][0] as List?;
      if (valueList1 != null && valueList1.isNotEmpty) {
        stat1Value = valueList1.last ?? 0; // Ambil stat level terakhir
      }
    }
  
    String stat2Type = 'N/A';
    int stat2Value = 0;
    // Cek apakah 'Type' punya elemen kedua
    if (stats['Type'] != null && (stats['Type'] as List).length > 1) {
      stat2Type = stats['Type'][1];
    }
    // Cek apakah 'Value' punya elemen kedua, dan list di dalamnya tidak kosong
    if (stats['Value'] != null && (stats['Value'] as List).length > 1) {
       var valueList2 = stats['Value'][1] as List?;
       if (valueList2 != null && valueList2.isNotEmpty) {
          stat2Value = valueList2.last ?? 0; // Ambil stat level terakhir
       }
    }
    // --- AKHIR PERBAIKAN ---

    return Weapon(
      name: json['Name'] ?? 'No Weapon',
      description: json['Desc'] ?? '',
      weaponType: json['Type'] ?? 'N/A', 
      imagePath: 'https://schaledb.s3.ap-northeast-2.amazonaws.com/images/weapon/${json['ImagePath'] ?? 'default'}.webp',
      stat1Type: stat1Type,
      stat1Value: stat1Value,
      stat2Type: stat2Type,
      stat2Value: stat2Value,
    );
  }
}