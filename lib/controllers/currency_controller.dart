class CurrencyController {
  // Simula uma taxa de câmbio (depois buscaremos de uma API)
  double get exchangeRate => 5.0; 

  double convert(String input) {
    if (input.isEmpty) return 0.0;
    
    final value = double.tryParse(input.replaceAll(',', '.'));
    
    if (value == null) throw Exception("Valor inválido");
    if (value < 0) throw Exception("Valor não pode ser negativo");

    return value * exchangeRate;
  }
}