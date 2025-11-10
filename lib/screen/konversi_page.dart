import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  String _selectedCurrency = 'IDR'; // Default ke IDR
  String _selectedTimezoneKey = 'WIB (GMT+7)';
  bool _isLoading = true;

  
  final Map<String, ({int offset, int resetHour})> _timezones = {
    'WIB (GMT+7)': (offset: 7, resetHour: 2),
    'WITA (GMT+8)': (offset: 8, resetHour: 3),
    'WIT (GMT+9)': (offset: 9, resetHour: 4),
    'London (GMT)': (offset: 0, resetHour: 19),
  };


  // Map untuk pilihan mata uang (hanya untuk UI)
  final Map<String, String> _currencies = {
    'IDR': 'IDR (Rupiah)',
    'USD': 'USD (Dolar AS)',
    'JPY': 'JPY (Yen Jepang)',
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Memuat preferensi yang tersimpan
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('selected_currency') ?? 'IDR';
      _selectedTimezoneKey =
          prefs.getString('selected_timezone_key') ?? 'WIB (GMT+7)';

      // Validasi
      if (!_timezones.containsKey(_selectedTimezoneKey)) {
        _selectedTimezoneKey = 'WIB (GMT+7)';
      }
      if (!_currencies.containsKey(_selectedCurrency)) {
        _selectedCurrency = 'IDR';
      }

      _isLoading = false;
    });
  }

  /// Menyimpan preferensi mata uang
  Future<void> _setCurrencyPreference(String? value) async {
    if (value == null || !_currencies.containsKey(value)) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = value;
    });
    await prefs.setString('selected_currency', value);
  }

  /// Menyimpan preferensi zona waktu
  Future<void> _setTimezonePreference(String? key) async {
    if (key == null || !_timezones.containsKey(key)) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTimezoneKey = key;
    });
    await prefs.setString('selected_timezone_key', key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Konversi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // --- PENGATURAN MATA UANG ---
                Text(
                  'Konversi Mata Uang',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.blue[300]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Pilih mata uang untuk ditampilkan di Pyroxene Shop.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),

                RadioListTile<String>(
                  title: const Text('IDR (Rupiah)'),
                  value: 'IDR',
                  groupValue: _selectedCurrency,
                  onChanged: _setCurrencyPreference,
                ),
                RadioListTile<String>(
                  title: const Text('USD (Dolar AS)'),
                  value: 'USD',
                  groupValue: _selectedCurrency,
                  onChanged: _setCurrencyPreference,
                ),
                RadioListTile<String>(
                  title: const Text('JPY (Yen Jepang)'),
                  value: 'JPY',
                  groupValue: _selectedCurrency,
                  onChanged: _setCurrencyPreference,
                ),

                const Divider(height: 32),

                // --- PENGATURAN ZONA WAKTU ---
                Text(
                  'Konversi Zona Waktu',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.blue[300]),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Pilih zona waktu untuk timer Server Reset di halaman Home.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(height: 16),

                // Dropdown untuk memilih zona waktu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimezoneKey,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Zona Waktu',
                    ),
                    dropdownColor: const Color(0xFF2A2A2A),
                    items: _timezones.keys.map((String key) {
                      // Ambil jam reset untuk ditampilkan di dropdown
                      final resetHour = _timezones[key]!.resetHour;
                      final formattedHour = resetHour.toString().padLeft(
                        2,
                        '0',
                      );

                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text('$key (Reset at $formattedHour:00)'),
                      );
                    }).toList(),
                    onChanged: _setTimezonePreference,
                  ),
                ),
              ],
            ),
    );
  }
}
