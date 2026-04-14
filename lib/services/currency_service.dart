import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final http.Client client;
  CurrencyService(this.client);

  Future<double> fetchExchangeRate() async {
    final response = await client.get(
      Uri.parse('https://economia.awesomeapi.com.br/json/last/USD-BRL')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['USDBRL']['bid']);
    } else {
      throw Exception('Falha ao buscar cotação');
    }
  }
}