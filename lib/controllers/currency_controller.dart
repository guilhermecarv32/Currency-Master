import '../services/currency_service.dart';

class CurrencyController {
  final CurrencyService service;
  double exchangeRate = 0.0;
  bool isLoading = false;

  CurrencyController(this.service);

  Future<void> updateRate() async {
    isLoading = true;
    try {
      exchangeRate = await service.fetchExchangeRate();
    } finally {
      isLoading = false;
    }
  }

  double convert(String input) {
    if (input.isEmpty) return 0.0;
    final value = double.tryParse(input.replaceAll(',', '.'));
    if (value == null || value < 0) return 0.0;
    return value * exchangeRate;
  }
}