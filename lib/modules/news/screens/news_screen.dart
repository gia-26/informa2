import 'dart:async';
import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/news/components/newsGrid_card.dart';
import 'package:informa2/modules/news/models/category_model.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/provider/news_provider.dart';
import 'package:informa2/modules/news/screens/news_details_screen.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String selectedCategory = 'Todo';
  int selectedCategoryId = 0;
  late Future<List<NewsModel>> _newsFuture;
  late Future<List<CategoryModel>> _categoriesFuture;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    _newsFuture = newsProvider.getNews(null);
    _categoriesFuture = newsProvider.getCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSearchBar(),
        ),
        const SizedBox(height: 20),

        FutureBuilder<List<CategoryModel>>(
          future: _categoriesFuture,
          builder: (context, categoriesSnapshot) {
            if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final categories = categoriesSnapshot.data ?? [];
            return SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    _buildCategoryItem(categories[index]),
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<List<NewsModel>>(
            future: _newsFuture,
            builder: (context, newsSnapshot) {
              if (newsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final newsList = newsSnapshot.data ?? [];

              if (newsList.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay noticias disponibles',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return NewsGridCard(
                    news: newsList[index],
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) =>
                              NewsDetailsScreen(news: newsList[index]),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    bool isSelected = selectedCategory == category.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category.name;
          selectedCategoryId = category.id;
          final newsProvider = Provider.of<NewsProvider>(
            context,
            listen: false,
          );

          if (category.id == 0 || category.name == 'Todo') {
            _newsFuture = newsProvider.getNews(null);
          } else {
            _newsFuture = newsProvider.getNews(category.id);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? secundaryColor.withOpacity(0.6)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();

          _debounce = Timer(const Duration(milliseconds: 500), () {
            _onSearchChanged(value);
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.3),
          ),
          hintText: 'Buscar noticias...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    setState(() {
      _newsFuture = newsProvider.searchNews(query, selectedCategoryId);
    });
  }
}
