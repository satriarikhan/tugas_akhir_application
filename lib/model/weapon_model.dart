// lib/model/weapon_model.dart (SUDAH DIPERBAIKI)

class Weapon {
  final String name;
  final String description;
  final String imagePath; // URL gambar senjata
  final String weaponType; // HG, SR, AR, dll. (untuk "Exclusive Weapon / HG")
  
  // Statistik senjata
  final String stat1Type;
  final int stat1Value;
  final String stat2Type;
  final int stat2Value;

  Weapon({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.weaponType,
    required this.stat1Type,
    required this.stat1Value,
    required this.stat2Type,
    required this.stat2Value,
  });

  factory Weapon.fromJson(Map<String, dynamic> json, String weaponType) {
    String weaponName = json['Name'] ?? 'Unknown Weapon';
    String weaponDesc = json['Desc'] ?? 'No description available.';
    
    // Default ke 'SR' jika tidak ada tipe senjata (contoh: Nonomi)
    String weaponType = json['WeaponType'] ?? 'SR'; 
    
    // --- PERBAIKAN URL GAMBAR DI SINI ---
    // Ganti server S3 ke server GitHub yang sudah pasti bisa
    String weaponImageId = json['Image'] ?? 'default'; // Ambil Image ID
    String weaponImageUrl = 
        'https://raw.githubusercontent.com/SchaleDB/SchaleDB/main/images/weapon/$weaponImageId.webp';
    // --- AKHIR PERBAIKAN URL GAMBAR ---

    // --- PERBAIKAN PEMBACAAN STATISTIK DI SINI ---
    // Inisialisasi default
    String stat1Type = 'ATK';
    int stat1Value = 0;
    String stat2Type = 'Max HP';
    int stat2Value = 0;

    var stats = json['WeaponStats'] as List?;
    if (stats != null && stats.isNotEmpty) {
      // Ambil stat pertama (biasanya AttackPower)
      var stat0 = stats[0] as Map<String, dynamic>?;
      if (stat0 != null) {
        stat1Type = _mapStatKeyToDisplayName(stat0['AttackPower'] != null ? 'AttackPower' : (stat0['MaxHP'] != null ? 'MaxHP' : 'CritChance'));
        stat1Value = stat0['AttackPower'] ?? stat0['MaxHP'] ?? stat0['CritChance'] ?? 0;
      }
      
      // Ambil stat kedua (biasanya MaxHP atau CritChance)
      if (stats.length > 1) {
        var stat1 = stats[1] as Map<String, dynamic>?;
        if (stat1 != null) {
          stat2Type = _mapStatKeyToDisplayName(stat1['MaxHP'] != null ? 'MaxHP' : (stat1['AttackPower'] != null ? 'AttackPower' : 'CritChance'));
          stat2Value = stat1['MaxHP'] ?? stat1['AttackPower'] ?? stat1['CritChance'] ?? 0;
        }
      }
    }
    // --- AKHIR PERBAIKAN STATISTIK ---

    return Weapon(
      name: weaponName,
      description: weaponDesc,
      imagePath: weaponImageUrl, // Gunakan URL yang sudah diperbaiki
      weaponType: weaponType,
      stat1Type: stat1Type,
      stat1Value: stat1Value,
      stat2Type: stat2Type,
      stat2Value: stat2Value,
    );
  }

  // Helper method untuk memetakan kunci JSON ke nama yang mudah dibaca
  static String _mapStatKeyToDisplayName(String key) {
    switch (key) {
      case 'AttackPower': return 'ATK';
      case 'MaxHP': return 'Max HP';
      case 'DefensePower': return 'DEF';
      case 'CritChance': return 'Crit Chance';
      case 'HealPower': return 'Heal Power';
      default: return key;
    }
  }
}