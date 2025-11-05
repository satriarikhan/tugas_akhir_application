// lib/model/profile_model.dart

class Profile {
  final String familyName; // Nama keluarga (cth: Rikuachima)
  final String personalName; // Nama pribadi (cth: Aru)
  final String birthday; // "July 24"
  final String age; // "16 years old"
  final String height; // "160cm"
  final String hobbies;
  final String voiceActor; // Seiyuu (JP)
  final String illustrator;

  // Teks pengenalan
  final String introduction; // Teks "catchphrase"
  final String profileComment; // Paragraf deskripsi

  Profile({
    required this.familyName,
    required this.personalName,
    required this.birthday,
    required this.age,
    required this.height,
    required this.hobbies,
    required this.voiceActor,
    required this.illustrator,
    required this.introduction,
    required this.profileComment,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    // --- PERBAIKAN 1: FORMAT HOBI ---
    // Hobi adalah List, kita gabungkan jadi satu String
    var hobbiesList = json['Hobbies'] as List<dynamic>?;
    String hobbiesText = hobbiesList?.join(', ') ?? 'N/A';
    // --- AKHIR PERBAIKAN 1 ---

    return Profile(
      familyName: json['FamilyName'] ?? 'N/A',
      personalName: json['PersonalName'] ?? 'N/A',
      birthday: json['Birthday'] ?? 'N/A',
      age: json['Age'] ?? 'N/A',
      height: json['Height'] ?? 'N/A',
      hobbies: hobbiesText, // Gunakan hobi yang sudah diformat
      voiceActor: json['CV'] ?? 'N/A',
      illustrator: json['Illustrator'] ?? 'N/A',
      introduction: json['Introduction'] ?? 'N/A',

      // --- PERBAIKAN 2: KUNCI JSON ---
      // Kunci JSON yang benar adalah 'ProfileComment', bukan 'Profile'
      profileComment: json['ProfileComment'] ?? 'N/A',
      // --- AKHIR PERBAIKAN 2 ---
    );
  }
}
