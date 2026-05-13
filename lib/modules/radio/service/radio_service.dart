import 'package:http/http.dart' as http;
import 'dart:convert';

class RadioService {
  final String apiUrl = "https://broadcast.freepi.io/radio/Api/programs_company_pagination/Radio%20by%20Freepi/10";

  Future<List<Map<String, dynamic>>> getRadios() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Access-key': '2025-RadioByFreepi*6808!?',
        }
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body)['results']);
      } else {
        throw Exception("Falló al cargar las radios: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching radios: $e");
      return [];
    }
  }
}