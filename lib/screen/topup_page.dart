// lib/screen/top_up_page.dart
// (FILE BARU)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas_akhir_application/service/currency_api_service.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  // State untuk konverter
  final CurrencyApiService _apiService = CurrencyApiService();
  Map<String, dynamic>? _rates;
  String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';
  double _inputAmount = 1.0;
  String _result = '';
  bool _isLoading = true;

  // Daftar mata uang yang kita dukung (memenuhi syarat min. 3)
  final List<String> _currencies = ['IDR', 'USD', 'JPY'];

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    try {
      final rates = await _apiService.getRates();
      setState(() {
        _rates = rates;
        _isLoading = false;
      });
      _convertCurrency(); // Langsung hitung konversi awal
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error: Gagal memuat kurs';
      });
    }
  }

  void _convertCurrency() {
    if (_rates == null) return;

    // Ambil kurs dari mata uang yang dipilih
    double fromRate = _rates![_fromCurrency]?.toDouble() ?? 1.0;
    double toRate = _rates![_toCurrency]?.toDouble() ?? 1.0;

    // Lakukan konversi
    // Rumus: (Amount / fromRate) * toRate
    // Karena base kita IDR, (Amount / IDR_Rate (selalu 1)) * Target_Rate
    double conversion = (_inputAmount / fromRate) * toRate;

    setState(() {
      _result = conversion.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up & Konversi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pyroxene Shop',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[300],
                  ),
            ),
            const SizedBox(height: 16),
            // Daftar item Top-up (Mock-up)
            _buildPyroxenePackage('Pyroxene x600', 'Rp 79.000'),
            _buildPyroxenePackage('Pyroxene x1200 (Bonus 220)', 'Rp 159.000'),
            _buildPyroxenePackage('Pyroxene x3280 (Bonus 720)', 'Rp 409.000'),
            _buildPyroxenePackage('Pyroxene x6600 (Bonus 1900)', 'Rp 829.000'),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            Text(
              'Konversi Mata Uang',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[300],
                  ),
            ),
            const SizedBox(height: 16),
            _buildConverterUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterUI() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_rates == null) {
      return Center(
        child: Text(
          _result,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Column(
      children: [
        // Baris Input (Dari)
        Row(
          children: [
            _buildCurrencyDropdown(_fromCurrency, (val) {
              setState(() {
                _fromCurrency = val!;
              });
              _convertCurrency();
            }),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: _inputAmount.toString()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  _inputAmount = double.tryParse(val) ?? 0;
                  _convertCurrency();
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),

        // Icon panah
        Icon(Icons.swap_vert, size: 40, color: Colors.grey[600]),

        const SizedBox(height: 16),
        
        // Baris Hasil (Ke)
        Row(
          children: [
            _buildCurrencyDropdown(_toCurrency, (val) {
              setState(() {
                _toCurrency = val!;
              });
              _convertCurrency();
            }),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 58, // Menyamakan tinggi dengan TextField
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _result,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper untuk Dropdown mata uang
  Widget _buildCurrencyDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2A2A2A),
          onChanged: onChanged,
          items: _currencies.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(currency, style: const TextStyle(fontSize: 18)),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper untuk paket Pyroxene
  Widget _buildPyroxenePackage(String title, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(Icons.diamond_outlined, color: Colors.cyan[200], size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price, style: TextStyle(color: Colors.green[300])),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Beli'),
        ),
      ),
    );
  }
}