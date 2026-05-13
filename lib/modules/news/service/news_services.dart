import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsServices {
  final String urlBase = "https://news.freepi.io/wp-json/wp/v2/posts";
  final String urlCategories = "https://news.freepi.io/wp-json/wp/v2/categories";

  Future<List<Map<String, dynamic>>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse(urlBase),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Falló al cargar las noticias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNewsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse("$urlBase?categories=$categoryId"),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Falló al cargar las noticias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchNews(String query, int categoryId) async {
    try {
      String categoriesUrl = "";
      if (categoryId == 0) {
        categoriesUrl = "";
      } else {
        categoriesUrl = "&categories=$categoryId";
      }
      final response = await http.get(
        Uri.parse("$urlBase?search=$query$categoriesUrl"),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Falló al cargar las noticias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(urlCategories),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Falló al cargar las categorias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
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