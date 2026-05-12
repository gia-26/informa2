import 'package:flutter/material.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/service/news_services.dart';

class NewsProvider extends ChangeNotifier {
  NewsServices _newsServices = NewsServices();

  Future<List<NewsModel>> getNews() async {
    try {
      final news = await _newsServices.getNews();
      List<Map<String, dynamic>> newsFormated = await Future.wait(
        news.map((n) async {
          final int id = n['id'];
          return {
            'id': id,
            'title': n['title']?['rendered'] ?? '',
            'content': n['content']?['rendered'] ?? '',
            'excerpt': n['excerpt']?['rendered'] ?? '',
            'imageUrl': await _newsServices.getImagen(
              n['_links']?['wp:featuredmedia']?[0]?['href'],
            ),
            'category': await _newsServices.getCategory(id.toString()),
            'date': DateTime.parse(n['date'].toString()),
          };
        }),
      );
      return newsFormated.map((n) => NewsModel.fromMap(n)).toList();
    } catch (e) {
      print("Error al obtener noticias: $e");
      return [];
    }
  }
}