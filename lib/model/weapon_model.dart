// lib/model/weapon_model.dart (GANTI SEMUA ISINYA DENGAN INI)

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
    // 'json' bisa jadi {} jika tidak ada data weapon
    
    // --- PERBAIKAN UTAMA: Tangani 'Stats' yang null ---
    // Jika json['Stats'] null, kita gunakan map kosong {} sebagai default
    var stats = json['Stats'] as Map<String, dynamic>? ?? {}; 
    
    String stat1Type = 'N/A';
    int stat1Value = 0;
    // Ambil list 'Type' dan 'Value' dari 'stats' (yang sekarang dijamin tidak null)
    var typeList = stats['Type'] as List?;
    var valueList = stats['Value'] as List?;

    // Cek typeList
    if (typeList != null && typeList.isNotEmpty) {
      stat1Type = typeList[0] ?? 'N/A';
    }
    
    // Cek valueList
    if (valueList != null && valueList.isNotEmpty) {
      var valueList1 = valueList[0] as List?;
      if (valueList1 != null && valueList1.isNotEmpty) {
        // Ambil stat level terakhir dan pastikan tipenya int
        stat1Value = (valueList1.last ?? 0) as int;
      }
    }
  
    String stat2Type = 'N/A';
    int stat2Value = 0;
    
    // Cek elemen kedua
    if (typeList != null && typeList.length > 1) {
      stat2Type = typeList[1] ?? 'N/A';
    }
    
    if (valueList != null && valueList.length > 1) {
       var valueList2 = valueList[1] as List?;
       if (valueList2 != null && valueList2.isNotEmpty) {
          // Ambil stat level terakhir dan pastikan tipenya int
          stat2Value = (valueList2.last ?? 0) as int;
       }
    }
  
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