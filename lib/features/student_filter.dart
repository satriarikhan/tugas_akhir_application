import 'package:flutter/material.dart';

// Widget ini adalah 'stateless' karena ia tidak menyimpan state-nya sendiri.
// Ia hanya menerima data dan fungsi 'onChanged' dari parent-nya.
class StudentFilterUI extends StatelessWidget {
  // Controller dan nilai yang sedang dipilih
  final TextEditingController searchController;
  final String? selectedSchool;
  final String? selectedAttackType;
  final String? selectedRole;

  // List opsi untuk dropdown
  final List<String> schools;
  final List<String> attackTypes;
  final List<String> roles;

  // Fungsi Callback yang akan dipanggil saat nilai berubah
  final ValueChanged<String?> onSchoolChanged;
  final ValueChanged<String?> onAttackTypeChanged;
  final ValueChanged<String?> onRoleChanged;

  const StudentFilterUI({
    super.key,
    required this.searchController,
    this.selectedSchool,
    this.selectedAttackType,
    this.selectedRole,
    required this.schools,
    required this.attackTypes,
    required this.roles,
    required this.onSchoolChanged,
    required this.onAttackTypeChanged,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    // UI yang kita pindahkan
    return Column(
      children: [
        _buildSearchBar(),
        _buildFilterRow(),
      ],
    );
  }

  // Widget helper untuk Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Cari nama siswa...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  // Widget helper untuk baris Filter
  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        children: [
          _buildDropdownFilter(
            hint: 'Sekolah',
            value: selectedSchool,
            items: schools,
            onChanged: onSchoolChanged, // Panggil callback
          ),
          const SizedBox(width: 8),
          _buildDropdownFilter(
            hint: 'Serangan',
            value: selectedAttackType,
            items: attackTypes,
            onChanged: onAttackTypeChanged, // Panggil callback
          ),
          const SizedBox(width: 8),
          _buildDropdownFilter(
            hint: 'Role',
            value: selectedRole,
            items: roles,
            onChanged: onRoleChanged, // Panggil callback
          ),
        ],
      ),
    );
  }

  // Widget helper generik untuk Dropdown
  Widget _buildDropdownFilter({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Sesuaikan dengan tema Anda
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          dropdownColor: const Color(0xFF2A2A2A),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}