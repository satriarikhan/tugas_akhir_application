// lib/models/item.dart

class Item {
  final int id;
  final String name;
  final String description;
  final String iconUrl;
  // ... stats, dll.

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
  });

  // Anda perlu API terpisah untuk mengambil detail item berdasarkan nama atau ID
  // factory Item.fromJson(Map<String, dynamic> json) { ... }
}