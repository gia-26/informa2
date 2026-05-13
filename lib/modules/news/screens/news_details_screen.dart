import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/provider/news_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsDetailsScreen extends StatefulWidget {
  final NewsModel news;

  const NewsDetailsScreen({Key? key, required this.news}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late bool isFavorite = false;
  late Future<List<NewsModel>> _newsFavorites;

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProviderApp>(context, listen: false);
    _newsFavorites = newsProvider.getFavoriteNews(authProvider.usuarioActual?.uid ?? '');
    // Verificar si la noticia actual está en favoritos
    _newsFavorites.then((favNews) {
      setState(() {
        isFavorite = favNews.any((n) => n.id == widget.news.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProviderApp>();
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: backgroundColor.withOpacity(0.7),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircularButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildCircularButton(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        onTap: () {
                          final uid = authProvider.usuarioActual?.uid;
                          if (uid == null) return;

                          if (isFavorite) {
                            newsProvider.removeNewsFromFavorites(uid, widget.news);
                            isFavorite = false;
                          } else {
                            newsProvider.addNewsToFavorites(uid, widget.news);
                            isFavorite = true;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'news_image_${widget.news.id}',
                          child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: NetworkImage(widget.news.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: secundaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: secundaryColor.withOpacity(0.3)),
                              ),
                              child: Text(
                                widget.news.category.toUpperCase(),
                                style: const TextStyle(
                                  color: secundaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Icon(Icons.access_time, size: 14, color: Colors.white.withOpacity(0.5)),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('dd MMM, yyyy').format(widget.news.dateTime),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text(
                          widget.news.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Html(
                          data: widget.news.content,
                          style: {
                            "body": Style(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: FontSize(16),
                              lineHeight: LineHeight(1.6),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              textAlign: TextAlign.justify,
                            ),
                            "p": Style(margin: Margins.only(bottom: 15)),
                            "strong": Style(color: secundaryColor),
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}