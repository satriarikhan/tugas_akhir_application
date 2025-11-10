import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoading = true;
  String _errorMessage = '';

  String _selectedCurrency = 'IDR'; // Default
  double _usdRate = 0.0; // Kurs IDR ke USD
  double _jpyRate = 0.0; // Kurs IDR ke JPY (BARU)

  // Formatter untuk mata uang
  final NumberFormat _idrFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Formatter baru
  final NumberFormat _usdFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  final NumberFormat _jpyFormatter = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadRatesAndPreferences();
  }

  Future<void> _loadRatesAndPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rates = await _apiService.getRates();

      setState(() {
        _rates = rates;
        _selectedCurrency = prefs.getString('selected_currency') ?? 'IDR';

        // Ambil kurs USD dan JPY dari hasil API
        if (_rates != null) {
          _usdRate = _rates!['USD']?.toDouble() ?? 0.000064; // Fallback
          _jpyRate = _rates!['JPY']?.toDouble() ?? 0.0097; // Fallback
        } else {
          _usdRate = 0.000064;
          _jpyRate = 0.0097;
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: Gagal memuat kurs mata uang';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Up & Konversi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SingleChildScrollView(
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
                  _buildPyroxenePackage('Pyroxene x600', 79000),
                  _buildPyroxenePackage('Pyroxene x1200 (Bonus 220)', 159000),
                  _buildPyroxenePackage('Pyroxene x3280 (Bonus 720)', 409000),
                  _buildPyroxenePackage('Pyroxene x6600 (Bonus 1900)', 829000),
                ],
              ),
            ),
    );
  }

  // Helper untuk format harga berdasarkan preferensi
  String _formatPrice(int idrPrice) {
    switch (_selectedCurrency) {
      case 'USD':
        double usdPrice = idrPrice * _usdRate;
        return _usdFormatter.format(usdPrice);
      case 'JPY':
        double jpyPrice = idrPrice * _jpyRate;
        return _jpyFormatter.format(jpyPrice);
      case 'IDR':
      default:
        return _idrFormatter.format(idrPrice);
    }
  }

  // Helper untuk paket Pyroxene
  Widget _buildPyroxenePackage(String title, int idrPrice) {
    String formattedPrice = _formatPrice(idrPrice);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          Icons.diamond_outlined,
          color: Colors.cyan[200],
          size: 36,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          formattedPrice,
          style: TextStyle(color: Colors.green[300]),
        ),
        trailing: ElevatedButton(onPressed: () {}, child: const Text('Beli')),
      ),
    );
  }
}
