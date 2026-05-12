import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsServices {
  final String apiUrl = "https://news.freepi.io/wp-json/wp/v2/posts";

  Future<List<Map<String, dynamic>>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );
      if (response.statusCode == 200) {
        print("Noticias obtenidas: ${response.body}");
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Falló al cargar las noticias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      return [];
    }
  }

  Future<String> getImagen(String apiUrlImage) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrlImage),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['source_url'] ?? '';
      } else {
        throw Exception("Falló al cargar la imagen: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
      return '';
    }
  }

  Future<String> getCategory(String idNew) async {
    String apiUrlCategory = "https://news.freepi.io/wp-json/wp/v2/categories?post=$idNew";
    try {
      final response = await http.get(
        Uri.parse(apiUrlCategory),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)[0]['name'] ?? '';
      } else {
        throw Exception("Falló al cargar la categoria: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching category: $e");
      return '';
    }
  }
}