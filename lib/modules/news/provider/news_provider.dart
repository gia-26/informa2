import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:informa2/modules/app/service/firestore_service.dart';
import 'package:informa2/modules/news/models/category_model.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/service/news_services.dart';

class NewsProvider extends ChangeNotifier {
  NewsServices _newsServices = NewsServices();
  FirestoreService _firestoreService = FirestoreService();
  List<NewsModel>? currentNews = [];
  List<NewsModel> _favoriteNews = [];
  List<NewsModel> get favoriteNews => _favoriteNews;

  Future<void> addNewsToFavorites(String uid, NewsModel news) async {
    try {
      await _firestoreService.addNews(uid, news);
      news.isFavorite = true;
      _favoriteNews.add(news);
      notifyListeners();
    } catch (e) {
      print("Error al agregar noticia a favoritos: $e");
    }
  }

  Future<void> removeNewsFromFavorites(String uid, NewsModel news) async {
    try {
      await _firestoreService.deleteNews(uid, news.id.toString());
      news.isFavorite = false;
      _favoriteNews.removeWhere((n) => n.id == news.id);
      notifyListeners();
    } catch (e) {
      print("Error al eliminar noticia de favoritos: $e");
    }
  }

  Future<List<NewsModel>> getFavoriteNews(String uid) async {
    try {
      List<NewsModel> favNews = await _firestoreService.getNewsFavorites(uid);
      return favNews;
    } catch (e) {
      print("Error al obtener noticias favoritas: $e");
      return [];
    }
  }

  Future<List<NewsModel>> getNews(int? categoryId) async {
    try {
      List<Map<String, dynamic>> news; 
      if (categoryId != null) news = await _newsServices.getNewsByCategory(categoryId);
      else news = await _newsServices.getNews();
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
      currentNews = newsFormated.map((n) => NewsModel.fromMap(n)).toList();
      return currentNews!;
    } catch (e) {
      print("Error al obtener noticias: $e");
      return [];
    }
  }

  Future<List<NewsModel>> searchNews(String query, int categoryId) async {
    try {
      List<Map<String, dynamic>> news = await _newsServices.searchNews(query, categoryId);
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
      currentNews = newsFormated.map((n) => NewsModel.fromMap(n)).toList();
      return currentNews!;
    } catch (e) {
      print("Error al buscar noticias: $e");
      return [];
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await _newsServices.getCategories();
      List<CategoryModel> categoriesList = [];
      categoriesList.add(CategoryModel(id: 0, name: 'Todo'));
      categoriesList.addAll(
        categories
            .where((c) => c['count'] > 0)
            .map((c) => CategoryModel.fromJson(c)),
      );
      return categoriesList;
    } catch (e) {
      print("Error al obtener categorías: $e");
      return [];
    }
  }
}